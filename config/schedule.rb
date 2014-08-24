# Log things
set :output, "/tmp/whenever.log"

# Set for easier management
Time.zone = "US/Central"

# Daily schedule
every 1.day, :at => Time.zone.parse('4:30 am').utc do
  rake "send_reminders:daily"
end

# Weekly schedule
every :monday, :at => Time.zone.parse('4 am').utc do
  rake "send_reminders:weekly"
end