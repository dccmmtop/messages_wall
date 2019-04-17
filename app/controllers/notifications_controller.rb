class NotificationsController < ApplicationController
  def index
    ids = Notification.select("distinct on (time_id) time_id ,id").to_sql
    @notices = Notification.select("category,notifications.id, admin_id,user_id,content, created_at").joins("inner join (#{ids}) as agg on agg.id = notifications.id ").page(params[:page]).order("created_at desc")
  end

  def new
    @notification = Notification.new(user_id: params[:user_id],content: params[:content])
  end

  def create
    if params[:nickname] == "all_user"
      time_id = Time.now.to_i
      User.select(:id).each do |user|
        @notification = Notification.new(user_id: user.id,content: params[:notification][:content], admin_id: params[:admin],category: 'all_user',time_id: time_id,is_read: false)
        if @notification.save
        else
          render :new
          return
        end
      end
      redirect_to new_notification_url,notice:'发布成功'
    else
      if params[:nickname].strip.length == 0 || User.find_by_nickname(params[:nickname]).nil?
        user_id = nil
      else
        user_id = User.find_by_nickname(params[:nickname]).id
      end
      @notification = Notification.new(user_id: user_id,content: params[:notification][:content], admin_id: params[:admin], time_id: Time.now.to_i, message_id: params[:message_id], is_read: false)
      if @notification.save
        redirect_to new_notification_path,notice:'发布成功'
      else
        render :new
      end
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    Notification.where("time_id = ?",@notification.time_id).delete_all

    redirect_to notifications_url, notice: "已删除"
  end
end
