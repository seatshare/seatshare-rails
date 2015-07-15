##
# Tickets controller
class TicketsController < ApplicationController
  before_action :authenticate_user!
  layout 'two-column'

  ##
  # View of user's future and past tickets
  def index
    if params[:filter] == 'past'
      @page_title = 'My Past Tickets'
      operator = '<'
    else
      @page_title = 'My Tickets'
      operator = '>='
    end
    @tickets = {
      owned:    Ticket.where("owner_id = #{current_user.id}")
                .joins(:group)
                .where('status = 1')
                .joins(:event)
                .where("start_time #{operator} '#{Time.now}'")
                .by_date.by_seat,
      assigned: Ticket.where("owner_id != #{current_user.id}")
                .where("user_id = #{current_user.id}")
                .joins(:group)
                .where('status = 1')
                .joins(:event)
                .where("start_time #{operator} '#{Time.now}'")
                .by_date.by_seat
    }
    render layout: 'single-column'
  end

  ##
  # Process cost updates from ticket index
  def bulk_update
    unless params[:ticket].nil?
      params[:ticket].each do |ticket_id, ticket_values|
        ticket = Ticket.find(ticket_id)
        next unless ticket.can_edit?(current_user)
        ticket.cost = ticket_values[:cost].to_f
        ticket.user_id = ticket_values[:user_id].to_i
        next unless ticket.cost_changed? || ticket.user_id_changed?
        if ticket.save
          log_ticket_history ticket, 'updated'
          flash[:notice] = 'Tickets updated!'
        else
          flash[:error] = 'Ticket cost could not be updated.'
        end
      end
    end
    redirect_to(
      controller: 'tickets', action: 'index', filter: params[:tickets][:filter]
    )
  end

  ##
  # New ticket form
  def new
    @group = Group.find_by_id(params[:group_id]) || not_found
    @ticket = Ticket.new(
      owner_id: current_user.id, user_id: current_user.id
    )

    @members = @group.members.by_name.collect { |p| [p.display_name, p.id] }
    @members.unshift(['Unassigned', 0])
    @user_aliases = current_user.user_aliases.by_name
                    .collect { |p| [p.display_name, p.id] }
    @user_aliases.unshift(['Not Set', 0])

    if params[:event_id]
      @event = Event.find_by_id(params[:event_id]) || not_found
      @ticket_stats = @event.ticket_stats(@group, current_user)
      @page_title = "#{@event.event_name}"
    else
      @events = @group.events
                .order('start_time ASC')
                .where("start_time > '#{Date.today}'")
      @page_title = 'Add Tickets'
    end
  end

  ##
  # Process ticket creation
  def create
    group = Group.find(params[:group_id])
    fail 'NotGroupMember' unless group.member?(current_user)
    ticket = Ticket.new(
      group_id: params[:group_id], section: ticket_params[:section],
      row: ticket_params[:row], seat: ticket_params[:seat],
      cost: ticket_params[:cost].gsub(/[^0-9\.]/, '').to_f,
      user_id: ticket_params[:user_id].to_i, owner_id: current_user.id
    )
    if !ticket_params[:alias_id].nil? &&
       ticket_params[:user_id].to_i == current_user.id
      ticket.alias_id = ticket_params[:alias_id].to_i
    else
      ticket.alias_id = 0
    end
    flash.keep
    if ticket_params[:event_id].is_a? String
      ticket.event_id = ticket_params[:event_id]
      if ticket.valid? && ticket.save
        log_ticket_history ticket, 'created'
        flash[:notice] = 'Ticket added!'
        redirect_to(
          controller: 'events', action: 'show', id: ticket_params[:event_id],
          group_id: group.id
        ) && return
      else
        flash[:error] = 'Could not create ticket.'
        redirect_to(
          controller: 'tickets', action: 'new', group_id: group.id
        ) && return
      end
    elsif params[:ticket][:event_id].is_a? Array
      params[:ticket][:event_id].each do |event_id|
        season_ticket = ticket.dup
        season_ticket.event_id = event_id
        if season_ticket.valid? && season_ticket.save
          log_ticket_history season_ticket, 'created'
          flash[:notice] = 'Tickets added!'
        else
          flash[:error] = 'Could not create tickets.'
        end
      end
      if flash[:error]
        redirect_to(
          controller: 'tickets', action: 'new', group_id: group.id
        ) && return
      else
        redirect_to(
          controller: 'groups', action: 'show', id: group.id
        ) && return
      end
    else
      flash[:error] = 'No events selected.'
      redirect_to(
        controller: 'tickets', action: 'new', group_id: group.id
      ) && return
    end
  end

  ##
  # Edit ticket properties if owner
  def edit
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:event_id]) || not_found
    @ticket = Ticket.find_by_id(params[:id]) || not_found
    if @ticket.assigned != current_user && @ticket.owner != current_user
      redirect_to action: 'request_ticket', id: @ticket.id
    end
    @ticket_stats = @event.ticket_stats(@group, current_user)
    @members = @group.members
               .by_name
               .by_name
               .collect { |p| [p.display_name, p.id] }
    @members.unshift(['Unassigned', 0])
    @user_aliases = current_user.user_aliases
                    .collect { |p| [p.display_name, p.id] }
    @user_aliases.unshift(['Unassigned', 0])
  end

  ##
  # Process ticket updates
  def update
    ticket = Ticket.find(params[:id])
    fail 'AccessDenied' unless ticket.can_edit?(current_user)
    fail 'NotGroupMember' unless ticket.group.member?(current_user)
    original_ticket = ticket.dup
    ticket.cost = ticket_params[:cost].gsub(/[^0-9\.]/, '').to_f
    ticket.user_id = ticket_params[:user_id].to_i
    ticket.note = ticket_params[:note]
    if !ticket_params[:alias_id].nil? &&
       ticket_params[:user_id].to_i == current_user.id
      ticket.alias_id = ticket_params[:alias_id].to_i
    else
      ticket.alias_id = 0
    end
    unless ticket_params[:ticket_file].nil?
      attrs = ticket_params
      attrs[:ticket_id] = ticket.id
      TicketFile.create_from_attrs(attrs)
    end
    flash.keep
    if ticket.save
      flash[:notice] = 'Ticket updated!'
      if ticket.user_id != current_user.id &&
         ticket.user_id != 0 &&
         original_ticket.user_id != ticket.user_id
        fail 'NotGroupMember' unless ticket.group.member?(ticket.assigned)
        TicketNotifier.assign(ticket, current_user).deliver
        TwilioSMS.new.assign_ticket(ticket, current_user)
        log_ticket_history ticket, 'assigned'
      else
        log_ticket_history ticket, 'updated'
      end
    else
      flash[:error] = 'Ticket could not be updated.'
    end
    redirect_to(
      controller: 'events', action: 'show', group_id: ticket.group.id,
      id: ticket.event_id
    ) && return
  end

  ##
  # Request a ticket if not owner
  def request_ticket
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:event_id]) || not_found
    @ticket = Ticket.find_by_id(params[:id]) || not_found
    fail 'NotGroupMember' unless @group.member?(current_user)
    @ticket_stats = @event.ticket_stats(@group, current_user)
    redirect_to(
      action: 'edit', id: @ticket.id
    ) if @ticket.assigned == current_user || @ticket.owner == current_user
  end

  ##
  # Process a ticket request
  def do_request_ticket
    ticket = Ticket.find_by_id(params[:id]) || not_found
    fail 'NotGroupMember' unless ticket.group.member?(current_user)
    message = params[:message][:personalization]
    TicketNotifier.request_ticket(ticket, current_user, message).deliver
    TwilioSMS.new.request_ticket(ticket, current_user)
    log_ticket_history ticket, 'requested'
    flash.keep
    flash[:notice] = 'Ticket request sent!'
    redirect_to(
      controller: 'events', action: 'show', group_id: ticket.group.id,
      id: ticket.event.id
    ) && return
  end

  ##
  # Process a ticket unassignment
  def unassign
    ticket = Ticket.find_by_id(params[:id]) || not_found
    fail 'AccessDenied' unless ticket.can_edit?(current_user)
    ticket.unassign
    log_ticket_history ticket, 'unassigned'
    flash.keep
    flash[:notice] = 'Ticket unassigned!'
    redirect_to(
      controller: 'events', action: 'show', group_id: ticket.group.id,
      id: ticket.event.id
    ) && return
  end

  ##
  # Process a ticket delete
  def delete
    ticket = Ticket.find_by_id(params[:id]) || not_found
    fail 'AccessDenied' unless ticket.can_edit?(current_user)
    ticket.destroy!
    flash.keep
    flash[:notice] = 'Ticket deleted!'
    redirect_to(
      controller: 'events', action: 'show', group_id: ticket.group.id,
      id: ticket.event.id
    ) && return
  end

  ##
  # Delete ticket file
  def delete_ticket_file
    ticket_file = TicketFile.find(params[:id]) || not_found
    ticket = ticket_file.ticket
    fail 'AccessDenied' unless ticket.can_edit?(current_user)
    ticket_file.destroy!
    redirect_to(
      controller: 'tickets', action: 'edit',
      group_id: ticket.group.id, event_id: ticket.event.id, id: ticket.id
    ) && return
  end

  private

  ##
  # Log a ticket history record
  # - ticket: Ticket object
  # - action: string of action
  def log_ticket_history(ticket = nil, action = nil)
    user = User.find_by_id(ticket.user_id)
    if !user.nil?
      user_record = user.attributes
    else
      user_record = nil
    end
    ticket_history = TicketHistory.new(
      event_id: ticket.event_id,
      user_id: current_user.id,
      ticket_id: ticket.id,
      group_id: ticket.group_id,
      entry: JSON.generate(
        text: action, user: user_record, ticket: ticket.attributes
      )
    )
    ticket_history.save
  end

  ##
  # Strong parameters for tickets
  def ticket_params
    params.require(:ticket).permit(
      :section, :row, :seat, :cost, :user_id, :alias_id, :event_id, :note,
      :ticket_file
    )
  end
end
