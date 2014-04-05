class TicketsController < ApplicationController

  before_action :authenticate_user!

  def edit
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:event_id]) || not_found
    @ticket = Ticket.find_by_id(params[:id]) || not_found

    @page_title = "#{@ticket.section_row_seat} | #{@event.event_name}"
  end

  def update
  end
end
