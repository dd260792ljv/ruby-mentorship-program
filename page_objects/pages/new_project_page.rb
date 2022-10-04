# frozen_string_literal: true

class NewProjectPage < SitePrism::Page
  section :header, HeaderSection, '.navbar.navbar-gitlab'
  section :menu, MenuSection, '[data-qa-title=Menu]'

  element :title, '.gl-display-flex > h2'
  element :create_blank_project_link, '.gl-display-flex> div:nth-child(2) > div:nth-child(1) > a'
  element :create_template_project_link, '.gl-display-flex> div:nth-child(2) > div:nth-child(2) > a'
  element :project_name, '#project_name'
  element :submit_btn, '[type=\'submit\']'
  elements :templates, '.template-option'
  element :selected_template, '.selected-template'

  def create_project(name)
    project_name.set name
    submit_btn.click
  end

  def select_template(template)
    header.menu_btn.click
    menu.new_project_btn.click
    create_template_project_link.click
    use_template(template)
  end

  def use_template(name)
    t = templates.select { |elem| elem.text.match(/#{name}/) }.first
    t.find(:css, '.choose-template').click
  end
end
