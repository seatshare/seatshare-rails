source 'https://rubygems.org'
ruby ENV['CUSTOM_RUBY_VERSION'] || '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.8'

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

# Foundation email-assets
gem 'foundation_emails'

# Premailer to inline CSS styles (requires nokogiri)
gem 'premailer-rails'

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
gem 'redcarpet', '~> 3.4.0'

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

# reCAPTCHTA
gem 'recaptcha', require: 'recaptcha/rails'

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'simplecov'
  gem 'dotenv-rails'
  gem 'bundler'
  gem 'guard-bundler'
  gem 'guard-livereload'
  gem 'guard-minitest'
  gem 'guard-rubocop'
  gem 'guard-spork'
  gem 'minitest'
  gem 'minitest-ci', github: 'circleci/minitest-ci'
  gem 'pry-coolline'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'rack-livereload'
  gem 'rubocop'
  gem 'spork-minitest', github: 'dekart/spork-minitest'
  gem 'spork-rails'
  gem 'webmock'
end
