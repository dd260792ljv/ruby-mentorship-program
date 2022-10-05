# frozen_string_literal: true

class ProjectPage < SitePrism::Page
  element :project_name, '[itemprop=name]'
end
