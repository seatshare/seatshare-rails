##
# Schedule Notifier class
class ScheduleNotifier < ActionMailer::Base
  default from: ENV['SEATSHARE_EMAIL_FROM']
  layout 'email'

  ##
  # Send a daily schedule
  # - events: array of Event objects
  # - group: Group object
  # - user: recipient User object
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

    headers['X-Mailgun-Tag'] = 'DailyReminder'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end

  ##
  # Send a weekly schedule
  # - events: array of Event objects
  # - group: Group object
  # - user: recipient User object
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

    headers['X-Mailgun-Tag'] = 'WeeklyReminder'
    headers['X-Mailgun-Dkim'] = 'yes'
    headers['X-Mailgun-Track'] = 'yes'
    headers['X-Mailgun-Track-Clicks'] = 'yes'
    headers['X-Mailgun-Track-Opens'] = 'yes'
  end

  private

  ##
  # Format a list of events by week day
  # - events: array of Event objects
  def events_day_of_week(events)
    events_day_of_week = []
    Date::DAYNAMES.each_with_index.to_a.rotate(1).each do |_, index|
      events_day_of_week[index] = []
      events.each do |event|
        next if event.start_time.wday != index
        events_day_of_week[index] << event
      end
    end
    events_day_of_week
  end

  ##
  # Set timezone based on user
  # - user: recipient User object
  def timezone(user)
    tz = user ? user.timezone : nil
    if tz.blank?
      Time.zone = ActiveSupport::TimeZone['Central Time (US & Canada)']
    else
      Time.zone = tz
    end
  end
end
