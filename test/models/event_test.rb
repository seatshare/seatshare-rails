require 'test_helper'

##
# Event test
class EventTest < ActiveSupport::TestCase
  ##
  # Setup test
  def setup
    Time.zone = 'Central Time (US & Canada)'
  end

  test 'new event has attributes' do
    event = Event.new(
      event_name: 'A New Event',
      description: 'This describes the event',
      entity_id: 1,
      start_time: '2013-01-01 18:00:00 CST'
    )
    event.save!

    assert event.id > 0, 'new event ID is set'
    assert event.event_name?, 'new event has a name'
    assert event.description?, 'new event has a description'
    assert event.start_time.acts_like_time?, 'new event start time is set'
    assert event.start_time.day == 1, 'new event day matches'
    assert event.date_tba? == false, 'new event date is not TBA'
    assert event.time_tba? == false, 'new event time is not TBA'
    fails_intermittently(
      'https://github.com/stephenyeargin/seatshare-rails/issues/109',
      'Rails.configuration.time_zone' => Rails.configuration.time_zone,
      'Time.zone.name' => Time.zone.name
    ) do
      assert(
        event.date_time == 'Tuesday, January 1, 2013 - 6:00 pm CST',
        'new event date/time string matches'
      )
      assert event.time == '6:00 pm CST', 'event time matches'
    end
  end

  test 'fixture event has attributes' do
    event = Event.find(1)

    assert(
      event.event_name == 'Belmont Bruins vs. Brescia',
      'fixture event name matches'
    )
    assert event.description.nil?, 'fixture event description is nil'
    assert event.start_time.acts_like_time?, 'fixture event start time is set'
    assert event.start_time.day == 26, 'fixture event day matches'
    assert event.date_tba? == false, 'event date is not TBA'
    assert event.time_tba? == true, 'event time is TBA'
    assert event.time == '', 'event time is empty'
    assert(
      event.date_time == 'Tuesday, November 26, 2013',
      'new event date/time string matches'
    )
  end

  test 'get events by group ID' do
    events = Group.find(1).events.order('start_time ASC')

    assert events[0].class.to_s == 'Event', 'returned item is an event'
    assert(
      events[0].event_name == 'Nashville Predators vs. Minnesota Wild',
      'event title matches'
    )
    assert events.count == 7, 'event count equals seven'
  end

  test 'get event by ticket ID' do
    event = Ticket.find(2).event

    assert event.id == 4, 'event ID matches'
    assert event.entity_id == 1, 'entity ID matches'
    assert(
      event.event_name == 'Nashville Predators vs. St. Louis Blues',
      'event name matches'
    )
  end

  test 'get ticket status counts' do
    event = Event.find(4)
    user = User.find(1)
    group = Group.find(1)

    stats = event.ticket_stats(group, user)

    assert stats.is_a? Hash
    assert stats[:available] == 1
    assert stats[:total] == 4
    assert stats[:held] == 1
    assert stats[:percent_full] == 75
  end

  test 'two created events do not share an import key' do
    event1 = Event.create(
      event_name: 'Event 1',
      entity_id: 1,
      start_time: '2014-01-01 12:00',
      import_key: ''
    )
    event2 = Event.create(
      event_name: 'Event 2',
      entity_id: 1,
      start_time: '2014-01-01 12:00',
      import_key: ''
    )

    assert event1[:event_name] == 'Event 1'
    assert event2[:event_name] == 'Event 2'
  end

  test 'imported row matches output' do
    row1 = {
      entity_id: 1,
      home_team: 'Nashville Predators',
      away_team: 'Colorado Avalanche',
      start_date_time: '20091008T200000-0400',
      time_certainty: 'not certain'
    }
    record = Event.import row1
    assert record[:event_name] == 'Colorado Avalanche vs. Nashville Predators'
    assert record[:start_time] == DateTime.parse('October 8, 2009 7:00 PM CDT')
    assert record[:date_tba] == 0
    assert record[:time_tba] == 1

    row2 = {
      entity_id: 1,
      home_team: 'Nashville Predators',
      away_team: 'San Jose Sharks',
      start_date_time: '20091022T200000-0400',
      time_certainty: 'certain'
    }
    record = Event.import row2
    assert record[:event_name] == 'San Jose Sharks vs. Nashville Predators'
    assert record[:start_time] == DateTime.parse('October 22, 2009 7:00 PM CDT')
    assert record[:date_tba] == 0
    assert record[:time_tba] == 0
  end

  test 'uses markdown for description' do
    event = Event.find(1)
    event.description = "**I'm a teapot**"

    assert_equal(
      event.description_md,
      "<p><strong>I&#39;m a teapot</strong></p>\n"
    )

    event.description = '[A link](http://google.com)'

    assert_equal(
      event.description_md,
      "<p><a href=\"http://google.com\">A link</a></p>\n"
    )
  end

  test 'user has tickets' do
    event = Event.find(4)
    user = User.find(1)

    assert event.user_has_ticket?(user) == true

    event = Event.find(2)
    user = User.find(1)

    assert event.user_has_ticket?(user) == false
  end

  test 'export as ics' do
    event = Event.find(1)
    ics = event.to_ics('http://example.com/1')

    assert ics.summary == 'Belmont Bruins vs. Brescia'
    assert ics.dtstart == '2013-11-26'
    assert ics.dtend.nil?
    assert ics.uid == 'belmont_20131126'
    assert ics.url.to_s == 'http://example.com/1'

    event = Event.find(4)
    ics = event.to_ics('http://example.com/4')

    assert ics.summary == 'Nashville Predators vs. St. Louis Blues'
    assert ics.dtstart == '2013-10-26T14:00:00-05:00'
    assert ics.dtend == '2013-10-26T17:00:00-05:00'
    assert ics.uid == 'preds_20131026'
    assert ics.url.to_s == 'http://example.com/4'
  end
end
