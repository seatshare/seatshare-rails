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
    events = Event.where('DATE(start_time) = \'2013-10-15\'').order_by_date
    group = Group.find(1)
    user = User.find(1)

    email = ScheduleNotifier.daily_schedule(events, group, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@myseatshare.com'], email.from
    assert_equal ['stonej@example.net'], email.to
    assert_equal 'Today\'s events for Geeks Watching Hockey', email.subject
    assert_includes(
      email.body.to_s,
      '<title>Today&#39;s events for Geeks Watching Hockey</title>'
    )
    assert_includes(
      email.body.to_s,
      '<td><a href="http://localhost:3000/groups/1/event-7">Nashville '\
        'Predators vs. Florida Panthers</a></td>'
    )
  end

  test 'send weekly schedule' do
    events = Event.where(
      'start_time >= \'2013-10-13\' AND start_time <= \'2013-10-20\''
    ).order_by_date
    group = Group.find(1)
    user = User.find(1)

    email = ScheduleNotifier.weekly_schedule(events, group, user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@myseatshare.com'], email.from
    assert_equal ['stonej@example.net'], email.to
    assert_equal 'The week ahead for Geeks Watching Hockey', email.subject
    assert_includes(
      email.body.to_s,
      '<title>The week ahead for Geeks Watching Hockey</title>'
    )
    assert_includes(
      email.body.to_s,
      '<td><a href="http://localhost:3000/groups/1/event-6">Nashville '\
        'Predators vs. Los Angeles Kings</a></td>'
    )
  end
end
