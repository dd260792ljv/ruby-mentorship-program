# frozen_string_literal: true

require 'capybara/rspec'
require 'dotenv/load'
require 'factory_bot'
require 'require_all'
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
Capybara.default_max_wait_time = 20

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
  config.example_status_persistence_file_path = '.rspec_status'
end
