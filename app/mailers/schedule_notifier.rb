class ScheduleNotifier < ActionMailer::Base
  default from: 'no-reply@myseatshare.com'
  layout 'email'

  def daily_schedule(events, group, user)
    timezone user

    @events = events
    @group = group
    @user = user

    @view_action = {
      url: url_for(
        controller: 'groups', action: 'show',
        id: @group.id, only_path: false
      ),
      action: 'View Tickets',
      description: 'See available tickets.'
    }

    mail(
      to: "#{user.display_name} <#{@user.email}>",
      subject: "Today's events for #{@group.group_name}"
    )

    headers['X-MC-Tags'] = 'DailyReminder'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
  end

  def weekly_schedule(events, group, user)
    timezone user

    @events_day_of_week = events_day_of_week(events)
    @group = group
    @user = user

    @view_action = {
      url: url_for(
        controller: 'groups', action: 'show', id: @group.id,
        only_path: false
      ),
      action: 'View Tickets',
      description: 'See available tickets.'
    }

    mail(
      to: "#{user.display_name} <#{@user.email}>",
      subject: "The week ahead for #{@group.group_name}"
    )

    headers['X-MC-Tags'] = 'WeeklyReminder'
    headers['X-MC-Subaccount'] = 'SeatShare'
    headers['X-MC-SigningDomain'] = 'myseatshare.com'
  end

  private

  def events_day_of_week(events)
    events_day_of_week = []
    for day_of_week, index in Date::DAYNAMES.each_with_index.to_a.rotate(1)
      events_day_of_week[index] = []
      events.each do |event|
        next if event.start_time.wday != index
        events_day_of_week[index] << event
      end
    end
    events_day_of_week
  end

  def timezone(user)
    tz = user ? user.timezone : nil
    if tz.blank?
      Time.zone = ActiveSupport::TimeZone['Central Time (US & Canada)']
    else
      Time.zone = tz
    end
  end
end
