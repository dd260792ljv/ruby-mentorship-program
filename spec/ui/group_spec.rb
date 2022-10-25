# frozen_string_literal: true

feature 'CRUD of group', :ui, js: true do
  sign_in_page = SignInPage.new
  let(:dashboard_page) { DashboardPage.new }
  let(:new_group_page) { NewGroupPage.new }
  let(:group_page) { GroupPage.new }

  group_name = Time.now.to_i.to_s
  new_group_name = group_name.reverse

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

  scenario 'User can create group', severity: :normal do
    dashboard_page.create_group_link.click
    expect(new_group_page.title.text).to eq('Create new group')
    new_group_page.create_group_link.click
    new_group_page.create_group(group_name)
    expect(page).to have_content("Group \'#{group_name}\' was successfully created.")
  end

  scenario 'User see group in the list and can open', severity: :minor do
    dashboard_page.open_groups_list
    expect(group_page.groups_row.count).to eq 1
    expect(group_page.find_group(group_name).present?).to eq true
    group_page.open_group(group_name)
    expect(group_page.group_name.text).to eq group_name
  end

  scenario 'User can edit group', severity: :minor do
    dashboard_page.open_groups_list
    group_page.edit_group(group_name, new_group_name)
    expect(page).to have_content("Group \'#{new_group_name}\' was successfully updated.")
  end

  scenario 'User can delete group', severity: :trivial do
    dashboard_page.open_groups_list
    group_page.delete_group(new_group_name)
    expect(page).to have_content("Group \'#{new_group_name}\' was scheduled for deletion.")
  end
end
