# frozen_string_literal: true

class SignInPage < SitePrism::Page
  set_url 'https://gitlab.testautomate.me/'

  element :register_link, '#signin-container > p > a'
end
