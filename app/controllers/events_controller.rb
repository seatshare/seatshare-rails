class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @group = Group.find_by_id(params[:group_id]) || not_found
    @event = Event.find_by_id(params[:id]) || not_found
    @page_title = "#{@event.event_name}"
  end
end
