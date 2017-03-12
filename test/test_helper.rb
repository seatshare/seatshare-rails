# Generates coverage reports
require 'simplecov'
SimpleCov.start do
  add_filter '/admin/'
end

$LOAD_PATH << 'test'
require 'rubygems'
require 'spork'
require 'webmock/minitest'
Aws.config.update(stub_responses: true)

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV['RAILS_ENV'] ||= 'test'

  require 'rails/application'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  module ActiveSupport
    ##
    # Test Case class
    class TestCase
      ActiveRecord::Migration.check_pending!

      # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
      # order.
      #
      # Note: You'll currently still have to declare fixtures explicitly in
      # integration tests
      # -- they do not yet inherit this setting
      fixtures :all

      # Add more helper methods to be used by all tests here...
    end
  end

  module ActionController
    ##
    # Test Case class
    class TestCase
      include Devise::TestHelpers
    end
  end

  ##
  # Devise Controller class
  class DeviseController
    include DeviseHelper
    include ActionView::Helpers::TagHelper
    helper_method :devise_error_messages!
    helper_method :content_tag
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end

# Public: provide debugging information for tests which are known to fail
# intermittently
#
# issue_link - url of GitHub issue documenting this intermittent test failure
# args       - Hash of debugging information (names => values) to output on a
#              failure
# block      - block which intermittently fails
#
# Example
#
#    fails_intermittently('https://github.com/github/github/issues/27807',
#      '@repo' => @repo, 'shas' => shas, 'expected' => expected) do
#      assert_equal expected, shas
#    end
#
# Re-raises any MiniTest::Assertion from a failing test assertion in the block.
#
# Returns the value of the yielded block when no test assertion fails.
def fails_intermittently(issue_link, args = {}, &_block)
  raise ArgumentError, 'provide a GitHub issue link' unless issue_link
  raise ArgumentError, 'a block is required' unless block_given?
  yield
rescue MiniTest::Assertion, StandardError => boom # we have a test failure!
  STDERR.puts "\n\nIntermittent test failure! See: #{issue_link}"

  if args.empty?
    STDERR.puts 'No further debugging information available.'
  else
    STDERR.puts "Debugging information:\n"
    args.keys.sort.each do |key|
      STDERR.puts "#{key} => #{args[key].inspect}"
    end
  end

  raise boom
end
