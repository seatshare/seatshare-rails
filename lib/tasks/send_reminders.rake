namespace :send_reminders do
  desc "Sends Daily Reminders"
  task daily: :environment do
    puts "[START] #{DateTime.now}"
    groups = Group.all
    start_time = Date.today.beginning_of_day
    end_time = Date.today.end_of_day
    puts "Sending Daily Reminders for events between #{start_time} and #{end_time}"
    for group in groups
      events = group.events.where("start_time >= '#{start_time}' AND start_time <= '#{end_time}'")
      if events.count > 0
        for group_user in group.group_users
          if group_user.daily_reminder === 1
            user = User.find(group_user.user_id)
            puts "- Sending #{user.display_name} (#{user.email}) for #{group.group_name}"
            ScheduleNotifier.daily_schedule(events, group, user).deliver
          end
        end
      else
        puts "- No events for #{group.group_name}"
      end
    end
    puts "Done!"
    puts "[END] #{DateTime.now}"
  end

  desc "Sends Weekly Reminders"
  task weekly: :environment do
    puts "[START] #{DateTime.now}"
    groups = Group.all
    start_time = Date.today.beginning_of_week
    end_time = Date.today.sunday + 7
    puts "Sending Weekly Reminders for events between #{start_time} and #{end_time}"
    for group in groups
      events = group.events.where("start_time >= '#{start_time}' AND start_time <= '#{end_time}'")
      if events.count > 0
        for group_user in group.group_users
          if group_user.weekly_reminder === 1
            user = User.find(group_user.user_id)
            puts "- Sending #{user.display_name} (#{user.email}) for #{group.group_name}"
            ScheduleNotifier.daily_schedule(events, group, user).deliver
          end
        end
      else
        puts "- No events for #{group.group_name}"
      end
    end
    puts "Done!"
    puts "[END] #{DateTime.now}"
  end

end
