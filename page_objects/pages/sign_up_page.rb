# frozen_string_literal: true

class SignUpPage < SitePrism::Page
  set_url CommonVars::SIGN_UP_URL

  element :first_name, '#new_user_first_name'
  element :last_name, '#new_user_last_name'
  element :username, '#new_user_username'
  element :email, '#new_user_email'
  element :password, '#new_user_password'
  element :submit_btn, '#new_new_user > div.submit-container > input'

  def sign_up_user(user)
    load
    first_name.set user.first_name
    last_name.set user.last_name
    username.set user.username
    email.set user.email
    password.set user.password
    submit_btn.click
  end
end
