class SessionsController < ApplicationController
  include SessionsHelper
  def new
     
  end

  def create
    @user = User.find_by_nickname(params[:nickname])
    if @user && @user.authenticate(params[:password]) && @user.is_admin?
      log_in @user
      redirect_to users_index_url
    else
      redirect_to login_url,alert:'用户名或者密码错误或不是管理员'
    end 
  end

  def destroy
    session.delete :user_id
    @current_user=nil
    redirect_to root_url
  end
end
