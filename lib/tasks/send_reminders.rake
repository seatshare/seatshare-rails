namespace :send_reminders do
  desc "Sends Daily Reminders"
  task daily: :environment do

    Time.zone = ActiveSupport::TimeZone["Central Time (US & Canada)"]

    puts "[START] #{Time.zone.now}"
    groups = Group.active
    puts "Sending Daily Reminders for events for today"
    for group in groups
      events = group.events.today.confirmed.by_date
      if events.count > 0
        for membership in group.memberships
          if membership.daily_reminder?
            user = User.find(membership.user_id)
            if (membership.mine_only?)
              has_tickets = events.map { |e| e.user_has_ticket?(user) }
              next unless has_tickets.include?(true)
            end
            puts "- Sending #{user.display_name} (#{user.email}) for #{group.group_name}"
            ScheduleNotifier.daily_schedule(events, group, user).deliver_now
          end
        end
      else
        puts "- No events for #{group.group_name}"
      end
    end
    puts "Done!"
    puts "[END] #{Time.zone.now}"
  end

  desc "Sends Weekly Reminders"
  task weekly: :environment do

    Time.zone = ActiveSupport::TimeZone["Central Time (US & Canada)"]

    puts "[START] #{Time.zone.now}"
    groups = Group.active
    puts "Sending Weekly Reminders for events for next seven days"
    for group in groups
    events = group.events.next_seven_days.confirmed.by_date
      if events.count > 0
        for membership in group.memberships
          if membership.weekly_reminder?
            user = User.find(membership.user_id)
            if (membership.mine_only?)
              has_tickets = events.map { |e| e.user_has_ticket?(user) }
              next unless has_tickets.include?(true)
            end
            puts "- Sending #{user.display_name} (#{user.email}) for #{group.group_name}"
            ScheduleNotifier.weekly_schedule(events, group, user).deliver_now
          end
        end
      else
        puts "- No events for #{group.group_name}"
      end
    end
    puts "Done!"
    puts "[END] #{Time.zone.now}"
  end

end
