# frozen_string_literal: true

class ProfileSection < SitePrism::Section
  element :current_user, '.current-user'
  element :sign_out_btn, '.sign-out-link'
end
