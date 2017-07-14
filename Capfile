# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'
require 'capistrano/rails'

# Use Dotenv
if File.exist? '.env'
  require 'dotenv'
  Dotenv.load
end

# Whenever (for scheduled jobs)
require 'whenever/capistrano'

# Slackistrano (for notifications)
require 'slackistrano/capistrano'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }

# Load Git SCM Plugin
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git
