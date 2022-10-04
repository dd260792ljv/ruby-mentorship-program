# frozen_string_literal: true

class HeaderSection < SitePrism::Section
  element :logo, '#logo'
  element :menu_btn, '[data-qa-title=Menu]'
end
