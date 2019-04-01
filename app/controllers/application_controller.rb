class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def login
    unless loged_in?
      redirect_to login_url
    end
  end
end
