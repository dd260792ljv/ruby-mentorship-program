# frozen_string_literal: true

class NewGroupPage < SitePrism::Page
  element :title, '.gl-display-flex > h2'
  element :create_group_link, '[href=\'#create-group-pane\']'
  element :group_name, '#group_name'
  element :submit_btn, '[type=\'submit\']'

  def create_group(name)
    group_name.set name
    submit_btn.click
  end
end
