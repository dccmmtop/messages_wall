class LimitsController < ApplicationController

  def create
    @limit = Limit.new(limit_params)
    @user  = @limit.user
    @limits = @user.limits.order("created_at desc")
    if @limit.save
      Notification.create(user_id: @user.id,content: "你被管理员限制不能发表留言和评论，原因：#{@limit.reason}", admin_id: current_user.id,category: 'limit',time_id: Time.now.to_i,is_read: false)
      @limit = Limit.new
    end
    render "users/show"
  end

  def edit
      @limit = Limit.find(params[:id])
      @limit.is_relived = true
      @limit.save
      Notification.create(user_id: @limit.user.id,content: "你已解除限制，可以留言和评论了", admin_id: current_user.id,category: 'limit',time_id: Time.now.to_i,is_read: false)
      redirect_to user_path(@limit.user),:notice => "已解除限制"
  end


  private

  def limit_params
    params.require(:limit).permit(:user_id,:reason,:day,:id)
  end
end
