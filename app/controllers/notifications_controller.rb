class NotificationsController < ApplicationController

  def index(*args)
    
  end

  def new
    @notification = Notification.new(user_id: params[:user_id],content: params[:content])
  end

  def create
    if params[:nickname] == "all_user"
      time_id = Time.now.to_i
      User.select(:id).each do |user|
        @notification = Notification.new(user_id: user.id,content: params[:notification][:content], admin_id: params[:admin],category: 'all_user',time_id: time_id)
        if @notification.save
        else
          render :new
          return
        end
      end
      redirect_to notifications_url, alert:'发布成功'
    else
      if params[:nickname].strip.length == 0 || User.find_by_nickname(params[:nickname]).nil?
        user_id = nil
      else
        user_id = User.find_by_nickname(params[:nickname]).id
      end
      @notification = Notification.new(user_id: user_id,content: params[:notification][:content], admin_id: params[:admin], time_id: Time.now.to_i)
      if @notification.save
        redirect_to notifications_url, alert:'发布成功'
      else
        render :new
      end
    end
  end
end
