# Log things
set :output, "/tmp/whenever.log"

# Nightly schedule
every 1.day :at => '11:00 pm' do
  rake "seatgeek:update_events"
end

# Daily schedule
every 1.day, :at => '9:30 am' do
  rake "send_reminders:daily"
  rake "sitemap:generate"
end

# Weekly schedule
every :monday, :at => '9 am' do
  rake "send_reminders:weekly"
end
