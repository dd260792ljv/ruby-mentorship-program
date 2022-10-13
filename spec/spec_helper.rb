# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require 'dotenv/load'
require 'factory_bot'
require 'require_all'
require "rspec/wait"
require 'selenium-webdriver'
require 'site_prism'

require_all 'lib'
require_all 'page_objects/sections'
require_all 'page_objects/pages'
require_all 'models'
require_all 'spec/support'

include ApiHelper

options = Selenium::WebDriver::Chrome::Options.new(args: %w[window-size=1800,1000])

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [options])
end

Capybara.default_max_wait_time = 15

Capybara.save_path = File.join(Dir.pwd, '/tmp/screenshots')
Capybara::Screenshot.append_timestamp = false
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  example.full_description.downcase.parameterize(separator: '_')
end
Capybara::Screenshot.register_driver(:selenium) do |driver, path|
  driver.browser.save_screenshot path
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
  config.example_status_persistence_file_path = '.rspec_status'
  config.wait_timeout = 5
end
