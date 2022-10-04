# frozen_string_literal: true

class DashboardPage < SitePrism::Page
  element :title, '.gl-font-size-h1'
  element :create_project_link, '.gl-display-flex > a:nth-child(1)'
  element :create_group_link, '.gl-display-flex > a:nth-child(2)'
end
