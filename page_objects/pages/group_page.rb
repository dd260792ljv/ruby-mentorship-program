# frozen_string_literal: true

class GroupPage < SitePrism::Page
  elements :groups_row, '.group-row'
  element :group_name, '[itemprop=name]'
  element :edit_group_btn, '[data-testid*=edit-group]'
  element :new_group_name, '#group_name'
  element :submit_btn, '[type=\'submit\']'
  element :delete_group_btn, '[data-testid*=remove-group]'
  element :confirm_removing_field, '#confirm_name_input'
  element :confirm_removing_code, '[data-testid=\'confirm-danger-phrase\'] > code'
  element :confirm_removing_btn, '.qa-confirm-button'

  def find_group(name)
    groups_row.select { |elem| elem.text.match(/#{name}/) }.first
  end

  def open_group(name)
    g = find_group(name)
    g.find(:css, '[data-testid=\'group-name\']').click
  end

  def edit_group(name, new_name)
    g = find_group(name)
    g.find('#__BVID__138').click
    edit_group_btn.click
    new_group_name.set ''
    new_group_name.set new_name
    submit_btn.click
  end

  def delete_group(name)
    g = find_group(name)
    g.find('#__BVID__138').click
    delete_group_btn.click
    delete_group_btn.click
    confirm_removing_field.set confirm_removing_code.text
    confirm_removing_btn.click
  end
end
