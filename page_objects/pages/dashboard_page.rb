# frozen_string_literal: true

class DashboardPage < SitePrism::Page
  section :header, HeaderSection, '.navbar.navbar-gitlab'
  section :profile, ProfileSection, '[data-track-label=\'profile_dropdown\']'

  element :create_project_link, '.gl-display-flex > a:nth-child(1)'
  element :create_group_link, '.gl-display-flex > a:nth-child(2)'
  elements :projects_row, '.project-row'

  def open_project(name)
    p = projects_row.select { |elem| elem.text.match(/#{name}/) }.first
    p.find(:css, '.text-plain').click
  end

  def logout
    header.profile_btn.click
    profile.sign_out_btn.click
  end
end
