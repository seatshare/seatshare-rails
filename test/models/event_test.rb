require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "new event has attributes" do
    event = Event.new({
      event_name: 'A New Event',
      description: 'This describes the event',
      entity_id: 1,
      start_time: '2013-01-01 18:00:00'
    })
    event.save!

    assert event.id > 0, 'new event ID is set'
    assert event.event_name?, 'new event has a name'
    assert event.description?, 'new event has a description'
    assert event.start_time.acts_like_time?, 'new event start time is set'
    assert event.start_time.day == 1, 'new event day matches'
    assert event.date_tba? === false, 'new event date is not TBA'
    assert event.time_tba? === false, 'new event time is not TBA'
  end

  test "fixture event has attributes" do
    event = Event.find(1)

    assert event.event_name === 'Belmont Bruins vs. Brescia', 'fixture event name matches'
    assert event.description.nil?, 'fixture event description is nil'
    assert event.start_time.acts_like_time?, 'fixture event start time is set'
    assert event.start_time.day === 26, 'fixture event day matches'
    assert event.date_tba? === false, 'event date is not TBA'
    assert event.time_tba? === true, 'event time is TBA'
  end

  test "get events by group ID" do
    events = Event.get_by_group_id(1)

    assert events[0].class.to_s === 'Event', 'returned item is an event'
    assert events[0].event_name === "Nashville Predators vs. St. Louis Blues", 'event title matches'
    assert events.count === 7, 'event count equals five'
  end

  test "get event by ticket ID" do
    event = Event.get_by_ticket_id(2)

    assert event.id === 1, 'event ID matches'
    assert event.entity_id === 2, 'entity ID matches'
    assert event.event_name === 'Belmont Bruins vs. Brescia', 'event name matches'
  end

end
