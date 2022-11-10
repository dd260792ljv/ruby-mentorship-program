# frozen_string_literal: true

feature 'Create project', js: true do
  sign_in_page = SignInPage.new
  let(:dashboard_page) { DashboardPage.new }
  let(:new_project_page) { NewProjectPage.new }
  let(:project_page) { ProjectPage.new }

  project1 = 'Test_Project_1'
  project2 = 'Test_Project_2'
  projects_count = 2

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

  scenario 'User can create blank project', severity: :critical do
    dashboard_page.create_project_link.click
    expect(new_project_page.title.text).to eq('Create new project')
    new_project_page.create_blank_project_link.click
    new_project_page.create_project(project1)
    expect(page).to have_content("Project \'#{project1}\' was successfully created.")
  end

  scenario 'User can create project from template', severity: :minor do
    new_project_page.select_template('Ruby on Rails')
    expect(new_project_page.selected_template.text).to eq('Ruby on Rails')
    new_project_page.create_project(project2)
    expect(page).to have_content('The project was successfully imported.')
  end

  scenario 'User can open project from dashboard', severity: :trivial do
    expect(dashboard_page.projects_row.count).to eq projects_count
    dashboard_page.open_project(project2)
    expect(project_page.project_name.text).to eq project2
  end
end
