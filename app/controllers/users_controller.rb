class UsersController < ApplicationController
  before_action :login
  def index
    params[:page] ||= 1
    @users = User.search(params[:filter]).order(created_at: :desc).page(params[:page]).per(24)
  end

  def show
    @user = User.find(params[:id])
    @limit = Limit.new(user_id: @user.id, day: 7)
    @user.limits.out_date.relived!
    @limits  = @user.limits.order("created_at desc").page(params[:page])
  end

  def destroy
    respond_to do |format|
      @user = User.find_by_id(params[:id])
      @user.destroy
      # format.json{ render json: {status: 0}}
      format.html { redirect_to :users, notice: "删除成功！"}
    end
  end
end
