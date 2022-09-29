# frozen_string_literal: true

feature 'Sign up user', js: true do
  sign_in_page = SignInPage.new
  let(:sign_up_page) { SignUpPage.new }
  let(:welcome_page) { WelcomePage.new }
  let(:dashboard_page) { DashboardPage.new }

  before(:all) do
    @user = build(:user)
    sign_in_page.load
    sign_in_page.register_link.click
  end

  after(:all) do
    delete_user(@user.username)
  end

  scenario 'User can register' do
    sign_up_page.sign_up_user(@user)
    expect(welcome_page.title.text).to include(@user.first_name)
    welcome_page.select_role('Software Developer', 'I want to store my code')
    expect(dashboard_page.title.text).to eq('Welcome to GitLab')
  end
end
