# frozen_string_literal: true

class WelcomePage < SitePrism::Page
  element :title, 'h2.gl-text-center'
  element :user_role, '#user_role'
  element :registration_objective, '#user_registration_objective'
  element :get_started_btn, '[type=submit]'

  def select_role(role, objective)
    user_role.find(:option, role).select_option
    registration_objective.find(:option, objective).select_option
    get_started_btn.click
  end
end
