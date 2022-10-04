# frozen_string_literal: true

feature 'Create project', js: true do
  sign_in_page = SignInPage.new
  let(:dashboard_page) { DashboardPage.new }
  let(:new_project_page) { NewProjectPage.new }

  before(:all) do
    @user = build(:user)
    create_user(@user)
  end

  before(:each) do
    sign_in_page.sign_in_user(@user)
  end

  after(:all) do
    delete_user(@user.username)
  end

  scenario 'User can create blank project' do
    dashboard_page.create_project_link.click
    expect(new_project_page.title.text).to eq('Create new project')
    new_project_page.create_blank_project_link.click
    new_project_page.create_project('test')
    expect(new_project_page).to have_content('Project \'test\' was successfully created.')
  end

  scenario 'User can create project from template' do
    new_project_page.select_template('Ruby on Rails')
    expect(new_project_page.selected_template.text).to eq('Ruby on Rails')
    new_project_page.create_project('test2')
    expect(new_project_page).to have_content('The project was successfully imported.')
  end
end
