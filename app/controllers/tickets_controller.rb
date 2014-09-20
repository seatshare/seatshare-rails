class TicketsController < ApplicationController

  before_action :authenticate_user!
  layout 'two-column'

  def new
    @group = Group.find_by_id(params[:group_id]) || not_found
    @ticket = Ticket.new({
      :owner_id => current_user.id,
      :user_id => current_user.id
    })

    @members = @group.users.order_by_name.collect {|p| [ p.display_name, p.id ] }
    @members.unshift(['Unassigned', 0])
    @user_aliases = current_user.user_aliases.order_by_name.collect {|p| [ p.display_name, p.id ] }
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

      log_ticket_history ticket, 'created'

      flash[:success] = "Ticket added!"
      redirect_to :controller => 'groups', :action => 'show', :id => group.id and return
    else
      for event_id in params[:ticket][:event_id]
        season_ticket = ticket.dup
        season_ticket.event_id = event_id
        season_ticket.save!

        log_ticket_history season_ticket, 'created'

      end
      flash[:success] = "Tickets added!"
      redirect_to :controller => 'groups', :action => 'show', :id => group.id and return
    end
  end

  def edit
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:event_id]) || not_found
    @ticket = Ticket.find_by_id(params[:id]) || not_found

    if @ticket.assigned != current_user && @ticket.owner != current_user
      redirect_to :action => 'request_ticket', :id => @ticket.id
    end

    @ticket_stats = @event.ticket_stats(@group, current_user)
    @members = @group.users.order_by_name.order_by_name.collect {|p| [ p.display_name, p.id ] }
    @members.unshift(['Unassigned', 0])
    @user_aliases = current_user.user_aliases.collect {|p| [ p.display_name, p.id ] }
    @user_aliases.unshift(['Unassigned', 0])

    @page_title = "#{@event.event_name} - #{@ticket.display_name}"
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

    if !ticket_params[:ticket_file].nil?
      uploaded_io = ticket_params[:ticket_file]
      File.open(Rails.root.join('tmp', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      if !File.exists?(Rails.root.join('tmp', 'uploads', uploaded_io.original_filename))
        raise "TicketFileNotSaved"
      end
      File.open(Rails.root.join('tmp', 'uploads', uploaded_io.original_filename), 'rb') do |file|
        file_s3_key = "#{params[:id]}-#{SecureRandom.hex}/#{uploaded_io.original_filename}"
        s3 = AWS::S3.new
        object = s3.buckets[ENV['SEATSHARE_S3_BUCKET']].objects[file_s3_key]
        object.write(open(file))
        ticket_file = TicketFile.new({
          file_name: uploaded_io.original_filename,
          user_id: ticket.owner_id,
          ticket_id: ticket.id,
          path: file_s3_key
        })
        ticket_file.save!
      end
    end

    if ticket.save

      flash[:success] = 'Ticket updated!'

      if ticket.user_id != current_user.id && ticket.user_id != 0 && original_ticket.user_id != ticket.user_id
        if !group.is_member(ticket.assigned)
          raise "NotGroupMember"
        end
        TicketNotifier.assign(ticket, current_user).deliver

        log_ticket_history ticket, 'assigned'
      else
        log_ticket_history ticket, 'updated'
      end
    else
      flash[:error] = 'Ticket could not be updated.'
    end
    redirect_to :controller => 'events', :action => 'show', :group_id => group.id, :id => ticket.event_id and return
  end

  def request_ticket
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:event_id]) || not_found
    @ticket = Ticket.find_by_id(params[:id]) || not_found

    if !@group.is_member(current_user)
      raise "NotGroupMember"
    end

    @ticket_stats = @event.ticket_stats(@group, current_user)

    @page_title = "#{@event.event_name} - #{@ticket.display_name}"
  end

  def do_request_ticket
    group = Group.find_by_id(params[:group_id]) || not_found
    event = Event.find_by_id(params[:event_id]) || not_found
    ticket = Ticket.find_by_id(params[:id]) || not_found

    if !group.is_member(current_user)
      raise "NotGroupMember"
    end

    message = params[:message][:personalization]

    TicketNotifier.request_ticket(ticket, current_user, message).deliver

    log_ticket_history ticket, 'requested'

    flash[:success] = 'Ticket request sent!'
    redirect_to :controller => 'events', :action => 'show', :group_id => group.id, :id => event.id and return
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

    log_ticket_history ticket, 'unassigned'

    flash[:success] = 'Ticket unassigned!'
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

    flash[:success] = 'Ticket deleted!'
    redirect_to :controller => 'events', :action => 'show', :group_id => group.id, :id => event.id and return
  end

  private

  def log_ticket_history(ticket=nil, action=nil)
    user = User.find_by_id(ticket.user_id)
    if !user.nil?
      user_record = user.attributes
    else
      user_record = nil
    end

    ticket_history = TicketHistory.new({
      :event_id => ticket.event_id,
      :user_id => current_user.id,
      :ticket_id => ticket.id,
      :group_id => ticket.group_id,
      :entry => JSON.generate({
        text: action,
        user: user_record,
        ticket: ticket.attributes
      })
    })
    ticket_history.save
  end

  def ticket_params
    params.require(:ticket).permit(:section, :row, :seat, :cost, :user_id, :alias_id, :event_id, :note, :ticket_file)
  end

end
