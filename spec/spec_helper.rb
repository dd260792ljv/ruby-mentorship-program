# frozen_string_literal: true

require 'capybara/rspec'
require 'dotenv/load'
require 'factory_bot'
require 'require_all'
require 'selenium-webdriver'
require 'site_prism'

require_all 'lib'
require_all 'pages'
require_all 'models'
require_all 'spec/support'

include ApiHelper

def options
  Selenium::WebDriver::Chrome::Options.new(args: %w[window-size=1800,1000])
end

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
