class GroupsController < ApplicationController

  before_action :authenticate_user!
  layout 'two-column', except: [:index]

  def index
    @page_title = "Groups"
    @groups = Group.get_groups_by_user_id(current_user.id)
    if @groups.blank?
      render 'groups/welcome'
    end
  end

  def new
    @page_title = "Create a Group"
    @entities = Entity.get_active_entities.collect {|p| [ p.entity_name, p.id ] }
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
  end

  def update
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
    @page_title = "Join a Group"
  end

  def leave
    @group = Group.find_by_id(params[:id]) || not_found
    @page_title = "Leave #{@group.group_name}"
  end

  private

  def group_params
    params.require(:group).permit(:group_name, :entity_id)
  end

end
