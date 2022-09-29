# frozen_string_literal: true

require 'rest-client'

module ApiHelper
  def create_user(user)
    response = RestClient.post "#{CommonVars::BASE_URL}/api/v4/users",
                               {
                                 "name": "#{user.first_name} #{user.last_name}",
                                 "username": user.username,
                                 "email": user.email,
                                 "password": user.password,
                                 "skip_confirmation": true
                               },
                               headers
    raise 'User was not created' unless response.code == 201
  end

  def get_user_by_name(username)
    RestClient.get "#{CommonVars::BASE_URL}/api/v4/users?username=#{username}", headers
  end

  def delete_user(username)
    user_id = JSON.parse(get_user_by_name(username).body)[0]['id']
    response = RestClient.delete "#{CommonVars::BASE_URL}/api/v4/users/#{user_id}", headers
    raise 'User was not deleted' unless response.code == 204
  end

  def headers
    { Authorization: 'Bearer FKzy_BpV5wAybKf7Z9JX' }
  end
end
