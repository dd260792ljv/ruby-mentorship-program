# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    username { "#{FFaker::Internet.user_name}_#{Time.now.to_i}" }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end
end
