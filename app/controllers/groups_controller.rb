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
  # Go to last active group
  def current
    if session[:current_group_id].is_a? Numeric
      redirect_to(
        controller: 'groups', action: 'show',
        id: session[:current_group_id], status: 302
      ) && return
    else
      redirect_to(
        controller: 'groups', action: 'index'
      )
    end
  end

  ##
  # New group form
  def new
    active_entities = Entity.active.includes(:entity_type).order(
      'entity_types.sort ASC'
    ).by_name
    @entity = Entity.find_by(id: params[:entity_id])
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
    entity = Entity.find_by(id: group_params[:entity_id]) || not_found
    group = Group.new(
      group_name: "#{entity.entity_name} Group",
      entity_id: group_params[:entity_id],
      creator_id: current_user.id
    )
    if group.save
      group.entity.seatgeek_import if group.events.future.empty?
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
    @group = Group.find_by(id: params[:id]) || not_found
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
    raise 'NotGroupAdmin' unless group.admin?(current_user)
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
    raise 'NotGroupMember' unless group.member?(current_user)
    daily = params[:membership][:daily_reminder]
    weekly = params[:membership][:weekly_reminder]
    mine = params[:membership][:mine_only]
    flash.keep
    status = Membership
             .where(user_id: current_user.id, group_id: group.id)
             .each do |membership|
               membership.update_attributes(
                 daily_reminder: daily, weekly_reminder: weekly, mine_only: mine
               )
             end
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
    @group = Group.find_by(id: params[:id]) || not_found
    @entity = @group.entity
    not_found unless @group.status?
    redirect_to(action: 'index') && return unless @group.member?(current_user)
    @events = @group.events.future.confirmed.by_date
    @members = @group.members.by_name
    session[:current_group_id] = @group.id
  end

  ##
  # JSON feed for calendar widget
  def events_feed
    @group = Group.find_by(id: params[:id]) || not_found
    not_found unless @group.status?
    raise 'NotGroupMember' unless @group.member?(current_user)
    @events = @group.events.confirmed.by_date

    feed = []
    @events.each do |event|
      next if event.date_tba == true
      event_link = url_for(
        controller: 'events', action: 'show', group_id: @group.id,
        id: event.id
      )
      feed << {
        date: event.start_time.strftime('%Y-%m-%d'),
        title: "#{event.time != '' ? event.time : 'TBA'} - #{event.event_name}",
        url: event_link,
        ticket_stats: event.ticket_stats(@group, current_user)
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
      group = Group.find_by(invitation_code: params[:group][:invitation_code])
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
    @group = Group.find_by(id: params[:id]) || not_found
    redirect_to(action: 'show', id: @group.id) && return \
      if @group.admin?(current_user)
  end

  ##
  # Process leaving a group
  def do_leave
    flash.keep
    user = if params[:user_id]
             User.find(params[:user_id])
           else
             current_user
           end
    group = Group.find_by(id: params[:id]) || not_found
    if user != current_user && !group.admin?(current_user)
      flash[:error] = 'You do not have permission to remove other users.'
      redirect_to(action: 'show', id: group.id) && return
    end
    group.leave_group(user)
    flash[:notice] = if user == current_user
                       "You have left #{group.group_name}"
                     else
                       "#{user.display_name} has been removed"
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
    @group = Group.find_by(id: params[:id]) || not_found
    redirect_to(action: 'show', id: @group.id) && return \
      unless @group.admin?(current_user)
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
      ).deliver_now
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
    raise 'AccessDenied' unless group.admin?(current_user)
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
    if params[:message][:recipients].blank?
      flash[:error] = 'You must select at least one recipient.'
      redirect_to(action: 'message', id: group.id) && return
    end
    subject = params[:message][:subject]
    message = params[:message][:message]
    recipients = User.find(params[:message][:recipients])
    email = GroupNotifier.send_group_message(
      group, current_user, recipients, subject, message
    ).deliver_now
    flash.keep
    if email
      flash[:notice] = 'Message sent!'
      redirect_to(action: 'show', id: group.id) && return
    else
      flash[:error] = 'Message delivery failed.'
      redirect_to(action: 'message', id: group.id) && return
    end
  end

  def do_request_notify
    group = Group.find(params[:id]) || not_found
    ContactMailer.support_ticket(
      current_user.display_name,
      current_user.email,
      "Requesting #{group.entity.entity_name} schedule",
      "Requestor: #{current_user.display_name}\n"\
        "Group Name: #{group.display_name}\n"\
        "Entity: #{group.entity.entity_name}"
    ).deliver_now
    flash[:notice] = 'Schedule request sent!'
    redirect_to(action: 'show', id: group.id) && return
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
