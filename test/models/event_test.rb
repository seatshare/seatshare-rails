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
    assert event.date_time === 'Tuesday, January 1, 2013 - 6:00 pm CST', 'new event date/time string matches'
  end

  test "fixture event has attributes" do
    event = Event.find(1)

    assert event.event_name === 'Belmont Bruins vs. Brescia', 'fixture event name matches'
    assert event.description.nil?, 'fixture event description is nil'
    assert event.start_time.acts_like_time?, 'fixture event start time is set'
    assert event.start_time.day === 26, 'fixture event day matches'
    assert event.date_tba? === false, 'event date is not TBA'
    assert event.time_tba? === true, 'event time is TBA'
    assert event.date_time === 'Tuesday, November 26, 2013', 'new event date/time string matches'
  end

  test "get events by group ID" do
    events = Group.find(1).events.order('start_time ASC')

    assert events[0].class.to_s === 'Event', 'returned item is an event'
    assert events[0].event_name === "Nashville Predators vs. Minnesota Wild", 'event title matches'
    assert events.count === 7, 'event count equals seven'
  end

  test "get event by ticket ID" do
    event = Ticket.find(2).event

    assert event.id === 4, 'event ID matches'
    assert event.entity_id === 1, 'entity ID matches'
    assert event.event_name === 'Nashville Predators vs. St. Louis Blues', 'event name matches'
  end

  test "get ticket status counts" do
    event = Event.find(4)
    user = User.find(1)
    group = Group.find(1)

    stats = event.ticket_stats(group, user)

    assert stats.is_a? Hash
    assert stats[:available] === 1
    assert stats[:total] === 2
    assert stats[:held] === 1
    assert stats[:percent_full] === 50
  end

  test "two created events do not share an import key" do
    event1 = Event.create({
        event_name: 'Event 1',
        entity_id: 1,
        start_time: '2014-01-01 12:00',
        import_key: ''
    })
    event2 = Event.create({
        event_name: 'Event 2',
        entity_id: 1,
        start_time: '2014-01-01 12:00',
        import_key: ''
    })

    assert event1[:event_name] === 'Event 1'
    assert event2[:event_name] === 'Event 2'

  end

end
