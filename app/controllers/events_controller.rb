##
# Events Controller class
class EventsController < ApplicationController
  before_action :authenticate_user!

  ##
  # Shows the list of tickets for an event
  def show
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:id]) || not_found
    @tickets = @event.tickets.where(group_id: @group.id).by_seat
    @ticket_stats = @event.ticket_stats(@group, current_user)
    @seatgeek_data = @event.seatgeek_data if @event.seatgeek?

    respond_to do |format|
      format.html { render :show }
      format.ics do
        cal = Icalendar::Calendar.new
        cal.append_custom_property 'name', @event.event_name
        cal.timezone do |t|
          tz = current_user ? current_user.timezone : nil
          if tz.blank?
            t.tzid = Time.zone.tzinfo.name
          else
            t.tzid = ActiveSupport::TimeZone.create(user.timezone).tzinfo.name
          end
        end
        cal.add_event(
          @event.to_ics(
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
