# Log things
set :output, "/tmp/whenever.log"

# Daily schedule
every 1.day, :at => '9:30 am' do
  rake "send_reminders:daily"
  rake "sitemap:generate"
end

# Weekly schedule
every :monday, :at => '9 am' do
  rake "send_reminders:weekly"
end
