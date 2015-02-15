##
# Registrations controller
class RegistrationsController < Devise::RegistrationsController
  ##
  # New registration form
  def new
    @user = User.new
    if params[:invite_code]
      @invite = GroupInvitation.find_by_invitation_code(params[:invite_code])
    else
      @invite = nil
    end
    if params[:entity_id]
      @entity = Entity.find_by_id(params[:entity_id])
    else
      @entity = nil
    end
    if params[:group_code]
      @group = Group.find_by_invitation_code(params[:group_code])
    else
      @group = nil
    end
    super
  end

  ##
  # Process new registration
  def create
    build_resource(sign_up_params)

    if resource.save

      # Send welcome email
      WelcomeEmail.welcome(resource).deliver

      # Newsletter signup
      if params[:newsletter_signup] == '1' && !ENV['MAILCHIMP_LIST_ID'].nil?
        subscribe_newsletter
      end

      send_conversion

      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        if params[:user][:invite_code]
          invite_code = params[:user][:invite_code]
          respond_with(
            resource,
            location: groups_join_path + '?invite_code=' + invite_code
          )
        elsif params[:user][:entity_id]
          entity_id = params[:user][:entity_id]
          respond_with(
            resource,
            location: groups_new_path + '?entity_id=' + entity_id
          )
        else
          respond_with resource, location: after_sign_up_path_for(resource)
        end
      else
        set_flash_message(
          :notice, :"signed_up_but_#{resource.inactive_message}"
        ) if is_flashing_format?
        expire_data_after_sign_in!
        respond_with(
          resource,
          location: after_inactive_sign_up_path_for(resource)
        )
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
  rescue Mailchimp::Error => e
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
end
