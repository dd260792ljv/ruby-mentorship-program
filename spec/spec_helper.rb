# frozen_string_literal: true

require 'allure-rspec'
require 'capybara/rspec'
require 'dotenv/load'
require 'factory_bot'
require 'require_all'
require 'rspec/retry'
require 'rspec/wait'
require 'selenium-webdriver'
require 'site_prism'

require_all 'lib'
require_all 'page_objects/sections'
require_all 'page_objects/pages'
require_all 'models'
require_all 'spec/support'

include ApiHelper

chrome_options = Selenium::WebDriver::Chrome::Options.new(args: %w[window-size=1800,1000])
firefox_options = Selenium::WebDriver::Firefox::Options.new(args: %w[window-size=1800,1000])

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  if ENV['BROWSER'] == 'chrome' || ENV['BROWSER'].nil?
    Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [chrome_options])
  elsif ENV['BROWSER'] == 'firefox'
    Capybara::Selenium::Driver.new(app, browser: :firefox, capabilities: [firefox_options])
  end
end

Capybara.default_max_wait_time = 15

AllureRspec.configure do |config|
  config.results_directory = 'tmp/allure-results'
  config.clean_results_directory = false
  config.severity_tag = :severity
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.formatter = AllureRspecFormatter

  if ENV['BROWSER'] == 'chrome'
    config.example_status_persistence_file_path = 'tmp/.rspec_chrome_status'
  elsif ENV['BROWSER'] == 'firefox'
    config.example_status_persistence_file_path = 'tmp/.rspec_firefox_status'
  else
    config.example_status_persistence_file_path = 'tmp/.rspec_api_status'
  end

  config.wait_timeout = 5

  config.after(:each, :js) do |example|
    if example.exception
      screenshot_name = (example.description.downcase + " #{Time.now.to_i}").split.join('_')
      screenshot_path = "#{File.join(Dir.pwd, "/tmp/screenshots/#{screenshot_name}.png")}"
      Capybara.save_screenshot(screenshot_path)
      puts "Screenshot Taken: #{screenshot_path}\n"

      Allure.add_attachment(
        name: 'Attachment',
        source: File.open(screenshot_path),
        type: Allure::ContentType::PNG,
        test_case: true
      )
    end
    Allure.parameter('BROWSER',  ENV['BROWSER'])
    Allure.suite(ENV['BROWSER'])
  end
end
