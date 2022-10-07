# frozen_string_literal: true

class DashboardPage < SitePrism::Page
  section :profile, ProfileSection, '[data-track-label=\'profile_dropdown\']'
  section :menu, MenuSection, '[data-qa-title=Menu]'

  element :create_project_link, '.gl-display-flex > a:nth-child(1)'
  element :create_group_link, '.gl-display-flex > a:nth-child(2)'
  elements :projects_row, '.project-row'

  def open_project(name)
    p = projects_row.select { |elem| elem.text.match(/#{name}/) }.first
    p.find(:css, '.text-plain').click
  end

  def open_groups_list
    menu.root_element.click
    menu.groups.click
    menu.your_groups_btn.click
  end

  def logout
    profile.root_element.click
    profile.sign_out_btn.click
  end
end
