class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:id]) || not_found
    @tickets = @event.tickets.order_by_seat
    @ticket_stats = @event.ticket_stats(@group, current_user)
  end
end
