class UsersController < ApplicationController
  def index
    params[:page] ||= 1
    @users = User.search(params[:filter]).page(params[:page])
  end
end
