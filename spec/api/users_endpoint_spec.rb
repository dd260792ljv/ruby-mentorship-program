# frozen_string_literal: true

feature '/users endpoint', js: true do
  status_keys = %w[emoji message availability message_html clear_status_at]

  before(:all) do
    @user = build(:user)
  end

  scenario 'Crate user' do
    response = create_user(@user)
    expect(response.code).to eq ApiHelper::CREATED_RESPONSE_CODE
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['username']).to eq @user.username
    expect(parsed_response['name']).to eq "#{@user.first_name} #{@user.last_name}"
  end

  scenario 'Find user by username' do
    response = get_user_by_name(@user.username)
    expect(response.code).to eq ApiHelper::VALID_RESPONSE_CODE
    expect(JSON.parse(response.body).first['state']).to eq 'active'
  end

  scenario 'Get status for newly created user' do
    response = get_user_status(@user.username)
    expect(response.code).to eq ApiHelper::VALID_RESPONSE_CODE
    parsed_response = JSON.parse(response.body)
    expect(parsed_response.keys).to eq status_keys
    expect(parsed_response.values.all?(&:blank?)).to eq true
  end

  scenario 'Delete user' do
    response = delete_user(@user.username)
    expect(response.code).to eq ApiHelper::NO_CONTENT_RESPONSE_CODE
    sleep 1
    expect { get_user_status(@user.username) }.to raise_error RestClient::NotFound
  end
end
