class ApplicationController < ActionController::Base
  add_flash_types :success, :warning
  def hello
    render html: "<h1>It works WASLAB05!</h1>".html_safe
  end
end
