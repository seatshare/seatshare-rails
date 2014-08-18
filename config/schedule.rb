# Log things
set :output, "/tmp/whenever.log"

# Daily schedule
every 1.day, :at => '4:30 am' do
  rake "send_reminders:daily"
end

# Weekly schedule
every :sunday, :at => '4:00 am' do
  rake "send_reminders:weekly"
end