# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'
require 'capistrano/rails'

# Bower (for assets)
require 'capistrano/bower'

# Use Dotenv
if File.exists? '.env'
  require 'dotenv'
  Dotenv.load
end

# Whenever (for scheduled jobs)
require 'whenever/capistrano'

# Slackistrano (for notifications)
require 'slackistrano'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }