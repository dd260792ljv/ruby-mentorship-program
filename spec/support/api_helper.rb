# frozen_string_literal: true

require 'rest-client'

module ApiHelper
  VALID_RESPONSE_CODE = 200
  CREATED_RESPONSE_CODE = 202
  NO_CONTENT_RESPONSE_CODE = 204
  NOT_FOUND_ERROR_CODE = 404

  def basic_request(method, url, opts = {})
    RestClient::Request.new({
                              method: method,
                              url: "#{CommonVars::BASE_URL}/api/v4/#{url}",
                              headers: headers,
                              payload: opts[:payload].nil? ? nil : opts[:payload]
                            }).execute
  end

  def create_user(user, opts = {})
    payload = {
      "name": "#{user.first_name} #{user.last_name}",
      "username": user.username,
      "email": user.email,
      "password": user.password,
      "skip_confirmation": true
    }
    opts[:payload] = payload
    basic_request(:post, '/users', opts)
  end

  def get_user_by_name(username)
    basic_request(:get, "/users?username=#{username}")
  end

  def get_user_status(username)
    basic_request(:get, "/users/#{username}/status")
  end

  def delete_user(username)
    user_id = JSON.parse(get_user_by_name(username).body)[0]['id']
    basic_request(:delete, "/users/#{user_id}")
  end

  def headers
    { Authorization: ENV['API_KEY'] }
  end
end
