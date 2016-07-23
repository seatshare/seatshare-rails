source 'https://rubygems.org'
ruby ENV['CUSTOM_RUBY_VERSION'] || '2.3.1'

# dotenv
gem 'dotenv-rails', groups: [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.5.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.4'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 2.7.2'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.1'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 4.0.5'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.3.2'

# Use thin instead of Webrick
gem 'thin', '~> 1.6.4'

# Use Bootstrap
gem 'bootstrap-sass', '~> 3.3.6'

# Use Font Awesome
gem 'font-awesome-rails', '~> 4.5.0.0'

# Use Devise
gem 'devise', '~> 3.5.4'

# API Gems
gem 'grape', '~> 0.16.2'
gem 'doorkeeper', '~> 3.1.0'
gem 'kaminari', '~> 0.16.3'
gem 'api-pagination', '~> 4.3.0'
gem 'grape-swagger', '~> 0.22.0'

# Javascript libraries
gem 'momentjs-rails', '~> 2.10.6'
gem 'underscore-rails', '~> 1.8.3'

# S3
gem 'aws-sdk', '~> 2.3.22'

# Postgres
gem 'pg', '~> 0.18.4'

# ActiveAdmin
gem 'activeadmin', github: 'activeadmin'
gem 'active_admin_importable', github: 'krhorst/active_admin_importable'

# Mailchimp API
gem 'mailchimp-api', '~> 2.0.6'

# SeatGeek data provider
gem 'seatgeek', '~> 1.0.0'

# Capistrano
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-rails', '~> 1.1.5'
gem 'capistrano-bower', '~> 1.1.0'
gem 'slackistrano', '~> 1.0.0', require: false

# Whenever
gem 'whenever', '~> 0.9.4', require: false

# Markdown Support
gem 'github-markdown', '~> 0.6.9'

# REST Client (for Google Analytics goal tracking)
gem 'rest-client', '~> 1.8.0'

# Paperclip
gem 'paperclip', '~> 5.0.0'

# Twilio / SMS related
gem 'twilio-ruby', '~> 4.9.0'
gem 'global_phone', '~> 1.0.1'

# Sitemaps
gem 'dynamic_sitemaps', '~> 2.0.0'

# iCalendar
gem 'icalendar', '~> 2.3.0'

# Slack Notifier
gem 'slack-notifier', '~> 1.5.1'

group :doc do
  gem 'sdoc', '~> 0.4.1', require: false
end

group :production do
  gem 'rails_12factor', '~> 0.0.3'
  gem 'newrelic_rpm', '~> 3.14.1.311'
end

group :test do
  gem 'webmock', '~> 1.22.3'
  gem 'guard-minitest', '~> 2.4.4'
  gem 'guard-spork', '~> 2.1.0'
  gem 'spork-rails', '~> 4.0.0'
  gem 'spork-minitest', github: 'dekart/spork-minitest'
  gem 'minitest-ci', github: 'circleci/minitest-ci'
end

group :development do
  gem 'rubocop', '~> 0.41.2'
  gem 'bundler', '~> 1.12.5'
  gem 'rack-livereload', '~> 0.3.16'
  gem 'guard-livereload', '~> 2.5.1'
  gem 'guard-bundler', '~> 2.1.0'
  gem 'guard-rubocop', '~> 1.2.0'
  gem 'pry-rails', '~> 0.3.4'
  gem 'pry-nav', '~> 0.2.4'
end
