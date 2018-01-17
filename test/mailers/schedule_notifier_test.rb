require 'test_helper'

##
# Schedule Notifier test
class ScheduleNotifierTest < ActionMailer::TestCase
  ##
  # Setup test
  def setup
    Time.zone = 'Central Time (US & Canada)'
  end

  test 'send daily schedule' do
    date = Time.zone.parse('2013-10-16').utc
    events = Event.where(
      start_time: date.beginning_of_day...date.end_of_day
    ).by_date
    group = Group.find(1)
    user = User.find(1)

    email = ScheduleNotifier.daily_schedule(events, group, user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [ENV['SEATSHARE_EMAIL_FROM']], email.from
    assert_equal ['stonej@example.net'], email.to
    assert_equal 'Today\'s events for Geeks Watching Hockey', email.subject
    assert_includes(
      email.html_part.to_s,
      '<title>Today\'s events for Geeks Watching Hockey</title>'
    )
    assert_includes(
      email.html_part.to_s,
      'http://localhost:3000/groups/1/event-7'
    )
    assert_includes(
      email.html_part.to_s,
      'Nashville Predators vs. Florida Panthers'
    )
    assert_includes(
      email.html_part.to_s,
      '1</span> available in the group</li>'
    )
    assert_includes(
      email.html_part.to_s,
      '2</span> total in the group</li>'
    )
    assert_includes(
      email.html_part.to_s,
      '1</span> held by you</li>'
    )
  end

  test 'send weekly schedule' do
    events = Event.where(
      'start_time >= \'2013-10-13\' AND start_time <= \'2013-10-20\''
    ).by_date
    group = Group.find(1)
    user = User.find(1)

    email = ScheduleNotifier.weekly_schedule(events, group, user).deliver_now

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal [ENV['SEATSHARE_EMAIL_FROM']], email.from
    assert_equal ['stonej@example.net'], email.to
    assert_equal 'The week ahead for Geeks Watching Hockey', email.subject
    assert_includes(
      email.html_part.to_s,
      '<title>The week ahead for Geeks Watching Hockey</title>'
    )
    assert_includes(
      email.html_part.to_s,
      'http://localhost:3000/groups/1/event-6'
    )
    assert_includes email.html_part.to_s, 'Predators vs. Los Angeles Kings'
    assert_includes(
      email.html_part.to_s,
      '1</span> available in the group</li>'
    )
    assert_includes(
      email.html_part.to_s,
      '2</span> total in the group</li>'
    )
    assert_includes(
      email.html_part.to_s,
      '1</span> held by you</li>'
    )
  end
end
