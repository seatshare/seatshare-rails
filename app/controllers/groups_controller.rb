##
# Groups controller
class GroupsController < ApplicationController
  before_action :authenticate_user!
  layout 'two-column', except: [:index]

  ##
  # Index view of groups or welcome page
  def index
    @groups = current_user.groups.active
    render 'groups/welcome' if @groups.blank?
  end

  ##
  # New group form
  def new
    active_entities = Entity.active.includes(:entity_type).order(
      'entity_types.sort ASC'
    ).by_name
    @entity = Entity.find_by_id(params[:entity_id])
    options = {}
    active_entities.each_with_object({}) do |e|
      (options[e.entity_type.display_name] ||= []) << [e.entity_name, e.id]
    end
    @entities = options
    @group = Group.new
  end

  ##
  # Processes a new group
  def create
    group = Group.new(
      group_name: group_params[:group_name],
      entity_id: group_params[:entity_id],
      creator_id: current_user.id
    )
    if group.save
      group.join_group current_user, 'admin'
      flash.keep
      flash[:notice] = 'Group created!'
      redirect_to action: 'show', id: group.id
    else
      flash.keep
      flash[:error] = 'Group could not be created.'
      redirect_to action: 'new', entity_id: params[:entity_id]
    end
  end

  ##
  # Edit group form
  def edit
    @group = Group.find_by_id(params[:id]) || not_found
    redirect_to(action: 'index') && return unless @group.member?(current_user)
    @members = @group.members.by_name
    @membership = Membership.where(
      "user_id = #{current_user.id} AND group_id = #{@group.id}"
    ).first
  end

  ##
  # Process group edits
  def update
    group = Group.find(params[:id]) || not_found
    fail 'NotGroupAdmin' unless group.admin?(current_user)
    group.group_name = group_params[:group_name]
    group.avatar = group_params[:avatar] unless group_params[:avatar].nil?
    group.avatar = nil if group_params[:remove_avatar] == '1'
    if group.save
      flash[:notice] = 'Group updated!'
    else
      flash[:error] = 'Group could not be updated.'
    end
    redirect_to(
      controller: 'groups', action: 'show', id: group.id
    ) && return
  end

  ##
  # Process notification edits
  def update_notifications
    group = Group.find(params[:id]) || not_found
    fail 'NotGroupMember' unless group.member?(current_user)
    daily = params[:membership][:daily_reminder].to_i
    weekly = params[:membership][:weekly_reminder].to_i
    mine = params[:membership][:mine_only].to_i
    flash.keep
    status = Membership
             .where("user_id = #{current_user.id} AND group_id = #{group.id}")
             .update_all(
               "daily_reminder=#{daily}, weekly_reminder=#{weekly}, "\
               "mine_only=#{mine}"
             )
    if status
      flash[:notice] = 'Reminder settings updated!'
    else
      flash[:error] = 'Reminder settings could not be updated.'
      redirect_to(
        controller: 'groups', action: 'edit', id: group.id
      ) && return
    end
    redirect_to(
      controller: 'groups', action: 'show', id: group.id
    ) && return
  end

  ##
  # Initial page after login for a group member
  def show
    @group = Group.find_by_id(params[:id]) || not_found
    @entity = @group.entity
    not_found if @group.status != 1
    redirect_to(action: 'index') && return unless @group.member?(current_user)
    @events = @group.events
              .future
              .by_date
    @group.entity.retrive_schedule if @events.count == 0
    @members = @group.members.by_name
    session[:current_group_id] = @group.id
  end

  ##
  # JSON feed for calendar widget
  def events_feed
    @group = Group.find_by_id(params[:id]) || not_found
    not_found if @group.status != 1
    fail 'NotGroupMember' unless @group.member?(current_user)
    @events = @group.events.by_date

    feed = []
    @events.each do |event|
      next if event.date_tba == 1
      event_link = url_for(
        controller: 'events', action: 'show', group_id: @group.id,
        id: event.id
      )
      feed << {
        date: event.start_time.strftime('%Y-%m-%d'),
        title: "#{event.time != '' ? event.time : 'TBA'} - #{event.event_name}",
        url: event_link
      }
    end
    render json: feed
  end

  ##
  # Join a group form
  def join
    @invite_code = params[:invite_code]
  end

  ##
  # Process a group join
  def do_join
    flash.keep
    begin
      # Use group invitation
      group = Group.find_by_invitation_code(params[:group][:invitation_code])
      # Fall back to normal user invitation
      if group.blank?
        invitation = GroupInvitation.get_by_invitation_code(
          params[:group][:invitation_code]
        )
        invitation.use_invitation
        group = invitation.group
      end
      group.join_group(current_user, 'member')
      flash[:notice] = 'Group joined!'
      redirect_to(action: 'show', id: group.id) && return
    rescue
      flash[:error] = 'The provided invitation code has already been used.'
      redirect_to(action: 'join') && return
    end
  end

  ##
  # Leave a group form
  def leave
    @group = Group.find_by_id(params[:id]) || not_found
    redirect_to(
      action: 'show', id: @group.id
    ) && return if @group.admin?(current_user)
  end

  ##
  # Process leaving a group
  def do_leave
    flash.keep
    if params[:user_id]
      user = User.find(params[:user_id])
    else
      user = current_user
    end
    group = Group.find_by_id(params[:id]) || not_found
    if user != current_user && !group.admin?(current_user)
      flash[:error] = 'You do not have permission to remove other users.'
      redirect_to(action: 'show', id: group.id) && return
    end
    group.leave_group(user)
    if user == current_user
      flash[:notice] = "You have left #{group.group_name}"
    else
      flash[:notice] = "#{user.display_name} has been removed"
    end
    if group.admin?(current_user)
      redirect_to(action: 'edit', id: group.id) && return
    else
      redirect_to(controller: 'groups', action: 'index') && return
    end
  end

  ##
  # Deactivate Group
  def deactivate
    @group = Group.find_by_id(params[:id]) || not_found
    redirect_to(
      action: 'show', id: @group.id
    ) && return unless @group.admin?(current_user)
  end

  ##
  # Process a group deactivation
  def do_deactivate
    group = Group.find(params[:id]) || not_found
    if group.deactivate
      flash[:notice] = 'Your group has been deactivated!'
      session.delete :current_group_id
    else
      flash[:error] = 'Unable to deactivate your group.'
    end
    redirect_to(
      action: 'index'
    ) && return
  end

  ##
  # Invite to a group form
  def invite
    @group = Group.find(params[:id]) || not_found
    @group_invitation = GroupInvitation.new
    @invite_link = "#{request.protocol}#{request.host_with_port}"\
      "#{new_user_registration_path}/group/#{@group.invitation_code}"
  end

  ##
  # Process a group invitation
  def do_invite
    group = Group.find(params[:id]) || not_found
    group_invitation = GroupInvitation.new(
      group_id: group.id,
      user_id: current_user.id,
      email: params[:group_invitation][:email]
    )
    flash.keep
    if group_invitation.save!
      GroupNotifier.create_invite(
        group_invitation,
        params[:group_invitation][:message]
      ).deliver
      flash[:notice] = 'Group invitation sent!'
    else
      flash[:error] = 'Unable to send group invitation.'
    end
    redirect_to(action: 'show', id: group.id) && return
  end

  ##
  # Process a group invitaiton code reset
  def do_reset_invite
    group = Group.find(params[:id]) || not_found
    fail 'AccessDenied' unless group.admin?(current_user)
    group.invitation_code = nil
    group.save!
    flash.keep
    flash[:notice] = 'Invitation code reset!'
    redirect_to(action: 'edit', id: group.id) && return
  end

  ##
  # Group message form
  def message
    @group = Group.find(params[:id]) || not_found
    @members = @group.members.by_name
  end

  ##
  # Process sending a group message
  def do_message
    group = Group.find(params[:id]) || not_found
    flash.keep
    if params[:message][:recipients].nil?
      flash[:error] = 'You must select at least one recipient.'
      redirect_to(action: 'message', id: group.id) && return
    end
    subject = params[:message][:subject]
    message = params[:message][:message]
    recipients = User.find(params[:message][:recipients])
    email = GroupNotifier.send_group_message(
      group, current_user, recipients, subject, message
    ).deliver
    flash.keep
    if email
      flash[:notice] = 'Message sent!'
      redirect_to(action: 'show', id: group.id) && return
    else
      flash[:error] = 'Message delivery failed.'
      redirect_to(action: 'message', id: group.id) && return
    end
  end

  private

  ##
  # Strong parameters for groups
  def group_params
    params.require(:group).permit(
      :group_name, :entity_id, :form_type, :avatar, :remove_avatar
    )
  end
end
