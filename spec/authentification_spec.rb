# frozen_string_literal: true

feature 'Authentication user', js: true do
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
    expect(dashboard_page).to have_content('Welcome to GitLab')
  end

  scenario 'User can login' do
    sign_in_page.sign_in_user(@user)
    expect(dashboard_page).to have_content('Welcome to GitLab')
    dashboard_page.header.profile_btn.click
    expect(dashboard_page.profile.current_user.text).to include(@user.first_name, @user.last_name, @user.username)
  end

  scenario 'User can logout' do
    sign_in_page.sign_in_user(@user)
    dashboard_page.logout
    expect(page.current_url).to eq CommonVars::SIGN_IN_URL
    expect(sign_in_page.register_link.visible?).to eq true
  end
end