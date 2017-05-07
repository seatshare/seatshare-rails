##
# Registrations controller
class RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication
  before_action :redirect_to_join_if_signed_in, if: :user_signed_in?

  ##
  # New registration form
  def new
    @user = User.new
    if params[:invite_code]
      @invite = GroupInvitation.find_by(invitation_code: params[:invite_code])
    else
      @invite = nil
    end
    if params[:entity_id]
      @entity = Entity.find_by(id: params[:entity_id])
      begin
        schedule = @entity.seatgeek_schedule
        @schedule = schedule['events']
      rescue StandardError
        @schedule = []
      end
      begin
        performer = @entity.seatgeek_performer
        @performer = performer
      rescue
        @performer = nil
      end
    else
      @entity = nil
    end
    @group = if params[:group_code]
               Group.find_by(invitation_code: params[:group_code])
             end
    super
  end

  ##
  # Process new registration
  def create
    build_resource(sign_up_params)

    if verify_recaptcha(model: resource) && resource.save

      # Send welcome email
      WelcomeEmail.welcome(resource).deliver_now

      # Newsletter signup
      if params[:newsletter_signup] == '1' && !ENV['MAILCHIMP_LIST_ID'].nil?
        subscribe_newsletter
      end

      send_conversion
      notify_slack(resource)

      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        if params[:user][:invite_code]
          register_with_invitation_code(params[:user][:invite_code], resource)
        elsif params[:user][:entity_id]
          entity_id = params[:user][:entity_id]
          respond_with(
            resource,
            location: groups_new_path + '?entity_id=' + entity_id
          )
        else
          respond_with resource, location: groups_new_path
        end
      else
        if is_flashing_format?
          set_flash_message(
            :notice, :"signed_up_but_#{resource.inactive_message}"
          )
        end
        expire_data_after_sign_in!
        respond_with(
          resource,
          location: after_inactive_sign_up_path_for(resource)
        ) && return
      end
    else
      flash[:alert] = 'There were errors with your registration.'
      clean_up_passwords resource
      respond_with resource
    end
  end

  ##
  # Process email and password updates
  def update
    super
  end

  private

  ##
  # Redirect to Join if Signed In
  def redirect_to_join_if_signed_in
    if params[:group_code] || params[:invite_code]
      redirect_to(
        controller: 'groups',
        action: 'join',
        invite_code: "#{params[:group_code]}#{params[:invite_code]}"
      ) && return
    end
    require_no_authentication unless %w[edit update].include? params[:action]
  end

  ##
  # Register with Invitation Code
  def register_with_invitation_code(invitation_code = nil, resource = nil)
    group = Group.join_with_invitation_code(invitation_code, resource)
    if group
      respond_with(
        resource,
        location: group_path(id: group.id)
      ) && return
    end
    respond_with(
      resource,
      location: root_path
    ) && return
  end

  ##
  # Subscribe Newsletter
  def subscribe_newsletter
    require 'mailchimp'
    mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
    merge_vars = {
      'FNAME' => sign_up_params[:first_name],
      'LNAME' => sign_up_params[:last_name]
    }
    mailchimp.lists.subscribe(
      ENV['MAILCHIMP_LIST_ID'],
      { 'email' => sign_up_params[:email] },
      merge_vars,
      'html',
      false,
      true,
      false,
      false
    )
  rescue StandardError => e
    # Sign up failed
    logger.info e.message
  end

  ##
  # Send Conversion
  def send_conversion
    # Measure in Google Analytics
    GoogleAnalyticsApi.new.event('user', 'signup', params[:ga_client_id])

    # Mark as Converted for Google AdWords
    flash[:conversion] = true
  end

  ##
  # Notify Slack
  def notify_slack(user = nil)
    return if user.nil? || ENV['SLACK_WEBHOOK_URL'].nil? ||
              Rails.env != 'production'
    notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL']
    notifier.ping "New user: #{user.display_name} <#{user.email}>",
                  icon_emoji: ':bust_in_silhouette:',
                  username: 'Signup Notifications'
  rescue StandardError => e
    logger.info e.message
  end
end
