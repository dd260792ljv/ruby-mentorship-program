# frozen_string_literal: true

require 'allure-rspec'
require 'capybara/rspec'
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



AllureRspec.configure do |config|
  config.results_directory = 'tmp/allure-results'
  config.clean_results_directory = true
  config.severity_tag = :severity
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.example_status_persistence_file_path = 'tmp/.rspec_status'

  config.wait_timeout = 5

  config.after(:each, :ui) do |example|
    if example.exception
      screenshot_name = example.full_description.downcase.split.join('_')
      screenshot_path = "#{File.join(Dir.pwd, "/tmp/screenshots/#{screenshot_name}.png")}"
      Capybara.save_screenshot(screenshot_path)
      puts  "Screenshot Taken: #{screenshot_path}\n"

      Allure.add_attachment(
        name: 'Attachment',
        source: File.open(screenshot_path),
        type: Allure::ContentType::PNG,
        test_case: true
      )
    end
  end
end
