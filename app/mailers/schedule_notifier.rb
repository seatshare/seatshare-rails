class ScheduleNotifier < ActionMailer::Base
  default from: "no-reply@myseatshare.com"
  layout 'email'

  def daily_schedule(events, group, user)
    @events = events
    @group = group
    @user = user

    mail(
      to: "#{user.display_name} <#{@user.email}>",
      subject: "Today's events for #{@group.group_name}"
    )
  end

  def weekly_schedule(events, group, user)

    events_day_of_week = []
    for day_of_week, index in Date::DAYNAMES.each_with_index.to_a.rotate(1)
      for event in events
        events_day_of_week[index] = []
        next if event.start_time.wday != index
        events_day_of_week[index] << event
      end
    end

    @events_day_of_week = events_day_of_week
    @group = group
    @user = user

    mail(
      to: "#{user.display_name} <#{@user.email}>",
      subject: "The week ahead for #{@group.group_name}"
    )
  end

end
