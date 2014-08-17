# config valid only for Capistrano 3.2.1
lock '3.2.1'

set :application, 'seatshare'
set :repo_url, 'git@github.com:stephenyeargin/seatshare-rails.git'

# Default branch is :master
# Uncomment the following line to have Capistrano ask which branch to deploy.
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Replace the sample value with the name of your application here:
set :deploy_to, '/u/apps/seatshare_production'

# Use agent forwarding for SSH so you can deploy with the SSH key on your workstation.
set :ssh_options, {
  forward_agent: true
}

# Default value for :pty is false
set :pty, true

set :linked_files, %w{config/database.yml .rbenv-vars}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :default_env, { path: "/opt/rbenv/shims:$PATH" }

set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end