source 'https://rubygems.org'

# dotenv
gem 'dotenv-rails', :groups => [:development, :test]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use thin instead of Webrick
gem 'thin'

# Use Bootstrap
gem 'bootstrap-sass', '~> 3.1.1'

# Use Font Awesome
gem "font-awesome-rails"

# Use Devise
gem 'devise'

# Javascript libraries
gem 'momentjs-rails'
gem 'underscore-rails'

# S3
gem 'aws-sdk'

# Postgres
gem 'pg'

# 12factor
gem 'rails_12factor', group: :production

# New Relic
gem 'newrelic_rpm', group: :production

# Select2
gem 'select2-rails'

# ActiveAdmin
gem 'activeadmin', github: 'activeadmin'

# Mailchimp API
gem 'mailchimp-api', '~> 2.0.5'

# SeatShare's own SODA gem
gem 'soda_xml_team', '~> 1.3.0'

# Capistrano
gem 'capistrano', '~> 3.2.1'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-bower', '~> 1.0'

# Whenever
gem 'whenever', :require => false

# REST Client (for Google Analytics goal tracking)
gem 'rest_client'

# Readline support (for remote console)
gem 'rb-readline'

# Paperclip
gem "paperclip", "~> 4.2"

# Twilio / SMS related
gem "twilio-ruby", '~> 3.12'
gem "global_phone", "~> 1.0.1"

# Sitemaps
gem "dynamic_sitemaps"

# testing
group :testing do
  gem 'guard-minitest'
  gem 'guard-spork'
  gem 'spork-rails'
  gem 'spork-minitest', github: 'dekart/spork-minitest'
end

group :development do
  gem 'rack-livereload'
  gem 'guard-livereload'
  gem 'guard-bundler', :group => :development
  gem 'guard-rubocop'
end
