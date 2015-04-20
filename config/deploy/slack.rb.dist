##
# Slackistrano (for notifying Slack)
set :slack_webhook,      ENV['SLACK_WEBHOOK_URL']
set :slack_icon_url,     ->{ 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
set :slack_icon_emoji,   ->{ nil } # will override icon_url, Must be a string (ex: ':shipit:')
set :slack_channel,      ->{ '#general' }
set :slack_username,     ->{ 'Capistrano' }
set :slack_run_starting, ->{ true }
set :slack_run_finished, ->{ true }
set :slack_run_failed,   ->{ true }
set :slack_msg_starting, ->{ "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}." }
set :slack_msg_finished, ->{ "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}." }
set :slack_msg_failed,   ->{ "*ERROR!* #{ENV['USER'] || ENV['USERNAME']} failed to deploy branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}." }
