# config valid only for Capistrano 3.2.1
lock '3.2.1'

set :application, 'seatshare'
set :repo_url, 'git@github.com:seatshare/seatshare-rails.git'

# Default branch is :master
# Uncomment the following line to have Capistrano ask which branch to deploy.
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Replace the sample value with the name of your application here:
set :deploy_to, '/u/apps/seatshare_production'

# Use agent forwarding for SSH so you can deploy with the SSH key on your workstation.
set :ssh_options, {
  forward_agent: true
}

# Fix binstub issues
set :bundle_binstubs, nil

# Default value for :pty is false
set :pty, true

set :linked_files, %w{config/database.yml .rbenv-vars}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/sitemaps}

set :default_env, { path: "/opt/rbenv/shims:$PATH" }

set :keep_releases, 5

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

##
# Whenever (for scheduled jobs)
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

##
# Generate Sitemap
namespace :sitemap do
  desc "Generate Sitemap"
  task :generate do
    on roles(:app) do |h|
      run_interactively "bundle exec rake RAILS_ENV=#{fetch(:rails_env)} sitemap:generate", h.user
      run_interactively "ln -s public/sitemaps/sitemap.xml public/sitemap.xml", h.user
    end
  end
end

##
# Capistrano console
namespace :rails do
  desc "Remote console"
  task :console do
    on roles(:app) do |h|
      run_interactively "bundle exec rails console #{fetch(:rails_env)}", h.user
    end
  end

  desc "Remote dbconsole"
  task :dbconsole do
    on roles(:app) do |h|
      run_interactively "bundle exec rails dbconsole #{fetch(:rails_env)}", h.user
    end
  end

  def run_interactively(command, user)
    info "Running `#{command}` as #{user}@#{host}"
    exec %Q(ssh #{user}@#{host} -t "bash --login -c 'cd #{fetch(:deploy_to)}/current && #{command}'")
  end
end
