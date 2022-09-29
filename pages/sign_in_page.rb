# frozen_string_literal: true

class SignInPage < SitePrism::Page
  set_url CommonVars::BASE_URL

  element :email, '#user_login'
  element :password, '#user_password'
  element :sign_in_btn, '#new_user > div.submit-container > button'
  element :register_link, '#signin-container > p > a'

  def sign_in_user(user)
    email.set user.email
    password.set user.password
    sign_in_btn.click
  end
end
