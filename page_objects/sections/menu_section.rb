# frozen_string_literal: true

class MenuSection < SitePrism::Section
  element :projects, '[aria-label=Projects]'
  element :groups, '[aria-label=Groups]'
  element :new_project_btn, '[aria-label=\'Create new project\']'
end
