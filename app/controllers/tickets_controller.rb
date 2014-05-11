class TicketsController < ApplicationController

  before_action :authenticate_user!
  layout 'two-column'

  def new
    @group = Group.find_by_id(params[:group_id]) || not_found
    @ticket = Ticket.new({
      :owner_id => current_user.id,
      :user_id => current_user.id
    })

    @members = @group.members.collect {|p| [ p.full_name, p.id ] }
    @members.unshift(['Unassigned', 0])
    @user_aliases = current_user.user_aliases.collect {|p| [ p.full_name, p.id ] }
    @user_aliases.unshift(['Not Set', 0])

    if params[:event_id]
      @event = Event.find_by_id(params[:event_id]) || not_found
      @ticket_stats = @event.ticket_stats(@group, current_user)
    else
      @events = @group.events.order('start_time ASC').where("start_time > '#{Date.today}'")
    end

    @page_title = "Add Tickets"   
  end

  def create
    group = Group.find(params[:group_id])
    if !group.is_member(current_user)
      raise "NotGroupMember"
    end

    ticket = Ticket.new({
      :group_id => params[:group_id],
      :section => ticket_params[:section],
      :row => ticket_params[:row],
      :seat => ticket_params[:seat],
      :cost => ticket_params[:cost].gsub(/[^0-9\.]/,'').to_f,
      :user_id => ticket_params[:user_id].to_i,
      :owner_id => current_user.id
    })

    if !ticket_params[:alias_id].nil? && ticket_params[:user_id].to_i == current_user.id
      ticket.alias_id = ticket_params[:alias_id].to_i
    else
      ticket.alias_id = 0
    end

    if ticket_params[:event_id].is_a? String
      ticket.event_id = ticket_params[:event_id]
      ticket.save!
      flash[:success] = "Ticket added!"
      redirect_to :controller => 'groups', :action => 'show', :id => group.id and return
    else
      for event_id in params[:ticket][:event_id]
        season_ticket = ticket.dup
        season_ticket.event_id = event_id
        season_ticket.save!
      end
      flash[:success] = "Tickets added!"
      redirect_to :controller => 'groups', :action => 'show', :id => group.id and return
    end
  end

  def edit
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:event_id]) || not_found
    @ticket = Ticket.find_by_id(params[:id]) || not_found

    @ticket_stats = @event.ticket_stats(@group, current_user)
    @members = @group.members.collect {|p| [ p.full_name, p.id ] }
    @members.unshift(['Unassigned', 0])
    @user_aliases = current_user.user_aliases.collect {|p| [ p.full_name, p.id ] }
    @user_aliases.unshift(['Unassigned', 0])

    @can_edit_ticket = @ticket.assigned === current_user || @ticket.owner === current_user

    @page_title = "#{@event.event_name} - #{@ticket.section_row_seat}"
  end

  def update
    group = Group.find(params[:group_id])
    if !group.is_member(current_user)
      raise "NotGroupMember"
    end

    ticket = Ticket.find(params[:id])
    original_ticket = ticket.dup

    ticket.cost = ticket_params[:cost].gsub(/[^0-9\.]/,'').to_f
    ticket.user_id = ticket_params[:user_id].to_i
    ticket.note = ticket_params[:note]

    if !ticket_params[:alias_id].nil? && ticket_params[:user_id].to_i == current_user.id
      ticket.alias_id = ticket_params[:alias_id].to_i
    else
      ticket.alias_id = 0
    end

    if ticket.save
      flash[:success] = 'Ticket updated!'

      if ticket.user_id != current_user.id && ticket.user_id != 0 && original_ticket.user_id != ticket.user_id
        if !group.is_member(ticket.assigned)
          raise "NotGroupMember"
        end
        TicketNotifier.assign(ticket, ticket.assigned).deliver
      else
        puts ticket.inspect
        puts original_ticket.inspect
      end

    else
      flash[:error] = 'Ticket could not be updated.'
    end
    redirect_to :controller => 'events', :action => 'show', :group_id => group.id, :id => ticket.event_id and return
  end

  def unassign
    group = Group.find_by_id(params[:group_id]) || not_found
    event = Event.find_by_id(params[:event_id]) || not_found
    ticket = Ticket.find_by_id(params[:id]) || not_found

    if ticket.owner_id != current_user.id && !ticket.assigned.nil? && ticket.assigned.id != current_user.id
      raise 'AccessDenied'
    end

    ticket.user_id = 0
    ticket.save!

    redirect_to :controller => 'events', :action => 'show', :group_id => group.id, :id => event.id and return
  end

  def delete
    group = Group.find_by_id(params[:group_id]) || not_found
    event = Event.find_by_id(params[:event_id]) || not_found
    ticket = Ticket.find_by_id(params[:id]) || not_found

    if ticket.owner_id != current_user.id
      raise 'AccessDenied'
    end

    ticket.destroy!

    redirect_to :controller => 'events', :action => 'show', :group_id => group.id, :id => event.id and return
  end

  private

  def ticket_params
    params.require(:ticket).permit(:section, :row, :seat, :cost, :user_id, :alias_id, :event_id, :note)
  end

end
