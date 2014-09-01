class GroupsController < ApplicationController

  before_action :authenticate_user!
  layout 'two-column', except: [:index]

  def index
    @page_title = "Groups"
    @groups = current_user.groups
    if @groups.blank?
      render 'groups/welcome'
    end
  end

  def new
    @page_title = "Create a Group"
    @entities = Entity.order_by_name.active.inject({}) do |options, entity|
      (options[entity.entity_type] ||= []) << [entity.entity_name, entity.id]
      options
    end
    @group = Group.new
  end

  def create
    @group = Group.new({
      :group_name => group_params[:group_name],
      :entity_id => group_params[:entity_id],
      :creator_id => current_user.id
    })

    if @group.save
      @group.join_group current_user, 'admin'
      flash[:success] = "Group created!"
      redirect_to :action => 'show', :id => @group.id
    end
  end

  def edit
    @page_title = "Edit Group"
    @group = Group.find_by_id(params[:id]) || not_found
    @members = @group.users.order_by_name
    @group_user = GroupUser.where("user_id = #{current_user.id} AND group_id = #{@group.id}").first
  end

  def update
    group = Group.find(params[:id])

    if params[:group_user].nil?

      if !group.is_admin(current_user)
        raise "NotGroupAdmin"
      end
      group.group_name = group_params[:group_name]
      if group.save
        flash[:success] = 'Group updated!'
      else
        flash[:error] = 'Group could not be updated.'
      end
    else

      if !group.is_member(current_user)
        raise "NotGroupMember"
      end
      daily_reminder = params[:group_user][:daily_reminder].to_i
      weekly_reminder = params[:group_user][:weekly_reminder].to_i
      if GroupUser.where("user_id = #{current_user.id} AND group_id = #{group.id}").update_all("daily_reminder = #{daily_reminder}, weekly_reminder = #{weekly_reminder}")
        flash[:success] = 'Reminder settings updated!'
      else
        flash[:error] = 'Reminder settings could not be updated.'
      end
    end

    redirect_to :controller => 'groups', :action => 'show', :id => group.id and return
  end

  def show
    @group = Group.find_by_id(params[:id]) || not_found
    if @group.status != 1
      not_found
    end
    if !@group.is_member(@current_user)
      redirect_to :action => 'index' and return
    end
    @events = @group.events.order('start_time ASC').where("start_time > '#{Date.today}'")
    @members = @group.users.order_by_name
    session[:current_group_id] = @group.id
    @page_title = @group.group_name
  end

  def events_feed
    @group = Group.find_by_id(params[:id]) || not_found
    if @group.status != 1
      not_found
    end
    if !@group.is_member(@current_user)
      raise "NotGroupMember"
    end
    @events = @group.events

    feed = []
    for event in @events
      event_link = url_for :controller => 'events', :action => 'show', :group_id => @group.id, :id => event.id
      feed << {
        :date => event.start_time.strftime('%Y-%m-%d'),
        :title => event.event_name,
        :url => event_link
      }
    end

    render json: feed
  end

  def join
    @invite_code = params[:invite_code]
    @page_title = "Join a Group"
  end

  def do_join
    begin

      # Use group invitation
      group = Group.find_by_invitation_code(params[:group][:invitation_code])

      # Fall back to normal user invitation
      if group.blank?
        invitation = GroupInvitation.get_by_invitation_code(params[:group][:invitation_code])
        invitation.use_invitation
        group = invitation.group
      end
      group.join_group(current_user, 'member')
      flash[:success] = 'Group joined!'
      redirect_to :action => 'show', :id => group.id and return

    rescue InvitationAlreadyUsed
      flash[:error] = "The provided invitation code has already been used."
      redirect_to :action => 'join' and return
    end

  end

  def leave
    @group = Group.find_by_id(params[:id]) || not_found
    if @group.is_admin(current_user)
      flash[:error] = "Administrator cannot leave group."
      redirect_to :action => 'show', :id => @group.id and return
    end
    @page_title = "Leave #{@group.group_name}"
  end

  def do_leave
    if params[:user]
      user = User.find(params[:user])
    else
      user = current_user
    end
    group = Group.find_by_id(params[:id]) || not_found
    if user != current_user && !group.is_admin(current_user)
      flash[:error] = "You do not have permission to remove other users."
      redirect_to :action => 'show', :id => group.id and return
    end

    group.leave_group(user)

    if user == current_user
      flash[:success] = "You have left #{group.group_name}"
    else
      flash[:success] = "#{user.display_name} has been removed"
    end

    if group.is_admin(current_user)
      redirect_to :action => 'edit', :id => group.id and return
    else
      redirect_to :controller => 'groups', :action => 'index' and return
    end
  end

  def invite
    @group = Group.find(params[:id]) || not_found
    @page_title = "Invite Member to #{@group.group_name}"
  end


  def do_invite
    group = Group.find(params[:id]) || not_found

    group_invitation = GroupInvitation.new({
      group_id: group.id,
      user_id: current_user.id,
      email: params[:group_invitation][:email]
    })

    if group_invitation.save!

      GroupNotifier.create_invite(group_invitation, params[:group_invitation][:message]).deliver
      flash[:success] = 'Group invitation sent!'

    else
      flash[:error] = 'Unable to send group invitation.'
    end

    redirect_to :action => 'show', :id => group.id and return
  end

  private

  def group_params
    params.require(:group).permit(:group_name, :entity_id, :form_type)
  end

end
