##
# Events Controller class
class EventsController < ApplicationController
  before_action :authenticate_user!

  ##
  # Shows the list of tickets for an event
  def show
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:id]) || not_found
    @tickets = @event.tickets.by_seat
    @ticket_stats = @event.ticket_stats(@group, current_user)

    respond_to do |format|
      format.html { render :show }
      format.ics do
        cal = Icalendar::Calendar.new
        cal.add_event(@event.to_ics(
            url_for(
              controller: 'events', action: 'show',
              id: @event.id, group_id: @group.id
            )
          )
        )
        response.headers['Content-Disposition'] = 'attachment;'\
          " filename=\"seatshare_#{@event.display_name.parameterize}.ics\""
        render text: cal.to_ical
      end
    end
  end
end
