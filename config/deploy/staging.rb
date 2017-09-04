set :deploy_to, '/u/apps/seatshare_staging'
server 'app.myseatshare.com', user: 'deploy', roles: %w{web app db}
