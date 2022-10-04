# frozen_string_literal: true

feature 'Sign in user', js: true do
  sign_in_page = SignInPage.new
  let(:dashboard_page) { DashboardPage.new }

  before(:all) do
    @user = build(:user)
    create_user(@user)
  end

  after(:all) do
    delete_user(@user.username)
  end

  scenario 'User can login' do
    sign_in_page.sign_in_user(@user)
    expect(dashboard_page.title.text).to eq('Welcome to GitLab')
  end
end
