module Api
  class NotificationsApi < Grape::API
    format :json
    desc "get all notice"
    params do
      requires :token, type: String, desc: "token"
    end

    get "get_all_notices" do
      user = User.find_by_token(params[:token])
      if(user.nil?)
        return {status: 401, message: '没有找到用户'}
      end
      result = {}
      result = {status: 0,data:[]}
      Notification.where("user_id = ?",user.id).order("created_at desc").each do |notice|
        result[:data] << {content: notice.content.truncate(15), created_at: notice.created_at.strftime( "%Y-%m-%d %H:%M"), is_read: notice.is_read}
      end
      return result
    end

    desc "get  notice by id"
    params do
      requires :token, type: String, desc: "token"
      requires :id, type: Integer, desc: "id"
    end
    get "get_notice" do
      user = User.find_by_token(params[:token])
      if(user.nil?)
        return {status: 401, message: '没有找到用户'}
      end
      result = {}
      result = {status: 0}
      notice = Notification.where("user_id = ? and id  = ?",user.id,params[:id])
      result[:data] = {content: notice.content, created_at: notice.created_at.strftime( "%Y-%m-%d %H:%M"), is_read: notice.is_read}
      return result
    end

    desc "清空已读消息"
    params do
      requires :token, type: String, desc: "token"
    end
    get "clear_notice" do
      user = User.find_by_token(params[:token])
      if(user.nil?)
        return {status: 401, message: '没有找到用户'}
      end
      result = {}
      result = {status: 0}
      notice = Notification.where("user_id = ? and is_read = ?",user.id,true).update_all(is_delete: true)
      result[:message] = "已清空"
      return result
    end

    desc "是否有未读消息"
    params do
      requires :token, type: String, desc: "token"
    end
    get "has_not_read" do
      user = User.find_by_token(params[:token])
      if(user.nil?)
        return {status: 401, message: '没有找到用户'}
      end
      result = {}
      result = {status: 0}
      notice = Notification.where("user_id = ? and is_read = ?",user.id,false).size
      result[:has_not_read] = (notice != 0)
      return result
    end
  end
end
