module Api
  class MessagesApi < Grape::API
    MAXDAYS = 10000000
    format :json
    desc "create message"

    params do
      requires :token, type: String, desc: "token"
      requires :content, type: String, desc: "message content"
      requires :latitude, type: String, desc: "纬度"
      requires :longitude, type: String, desc: "经度"
      requires :limit_user_accounts, type: Integer, desc: "观看人数限制"
      requires :limit_days, type: Integer, desc: "时间限制"
      requires :is_comment, type: Boolean, desc: "是否允许评论"
      requires :location, type: String, desc: "位置描述"
    end
    post "create" do 
      @user = User.find_by_token(params[:token])
      return {status:200,message:'没有找到该用户'} if @user.nil?
      (params[:limit_days].nil?) ? params[:limit_days] = MessagesApi::MAXDAYS : '' 
      @message = Message.new(user_id: @user.id,
                             content: params[:content],
                             latitude: params[:latitude],
                             longitude: params[:longitude],
                             limit_days: params[:limit_days].to_i,
                             limit_user_accounts: params[:limit_user_accounts],
                             location: params[:location],
                             is_comment: params[:is_comment])
      if @message.save
        return {status: 0, message: "留言成功"}
      else
        return {status: 201, message: @message.errors.full_messages.join(',')}
      end
    end

    desc "一千米以内所有未过期的留言"
    params do
      requires :latitude, type: Float, desc: "用户纬度"
      requires :longitude, type: Float, desc: "用户经度"
    end
    get "get_messages_by_km" do
      @origin = Geokit::LatLng.new(params[:latitude], params[:longitude])
      @messages = Message.within(1,:origin => @origin).all
      data = {}
      data[:status] = 0
      data[:message] = ""
      data[:sum] = @messages.count
      data[:result] = @messages.map do |m|
        {id: m.id, latitude: m.latitude, longitude: m.longitude, location: m.location}
      end
      return data
    end

    desc "查看留言详细内容"
    params do
      requires :id, type: Integer, desc: "留言id"
      requires :token, type: String, desc: "token"
    end
    get "get_messages_by_id" do
      u = User.find_by_token(params[:token])
      m = Message.find_by_id(params[:id])
      m.read_by_user(u)
      if m
        return {status: 0, result: {id: m.id, location: m.location, content: m.content, limit_days: (m.limit_days == MessagesApi::MAXDAYS  ? '' : m.limit_days),
                                    like_counts: m.likes.count,liked: m.liked_by_user?(u),is_comment: m.is_comment,
                                    published_at: m.created_at.strftime( "%Y-%m-%d %H:%M"),read_counts: m.reads.count,comment_counts: m.comments.count,
                                    user: {avatar: m.user.avatar.url.gsub("public","") + "?time=#{m.user.updated_at.to_i}", nickname: m.user.nickname}
        }}
      else
        return {status: 202, message: '没有找到'}
      end
    end

    desc "删除留言"
    params do
      requires :token, type: String, desc: "token"
      requires :id, type: Integer, desc: "留言id"
    end
    post "delete_messages_by_id" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '删除失败，没有该用户'} if u.nil?
      m = Message.find_by("user_id = ? and id = ?", u.id, params[:id])
      if m
        m.update(is_delete: true)
        return {status: 0,message: "删除成功"}
      else
        return {status: 202, message: '删除失败，没有找到文章'}
      end
    end

    desc "更新留言"
    params do
      requires :token, type: String, desc: "token"
      requires :id, type: Integer, desc: "留言id"
      requires :content, type: String, desc: "message content"
      requires :limit_days, type: Integer, desc: "时间限制"
      requires :is_comment, type: Boolean, desc: "是否允许评论"
    end
    post "update_message" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '没有这个用户'} if u.nil?
      m = Message.find_by("user_id = ? and id = ?", u.id, params[:id])
      return {status: 203, message: '没有找到'} if m.nil?
      info = {content: params[:content], limit_days: params[:limit_days].to_i, is_comment: params[:is_comment]}
      if m.update(info)
        return {status: 0,message: "更新成功"}
      else
        return {status: 204,message: m.errors.full_messages.join(",")}
      end
    end

    desc "留言列表"
    params do
      requires :token, type: String, desc: "token"
    end
    get "show_messages" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '没有这个用户'} if u.nil?
      @messages = u.messages
      data = {}
      data[:status] = 0
      data[:message] = ""
      data[:owner] = u.id
      data[:sum] = @messages.count
      data[:result] = @messages.map do |m|
        {id: m.id, latitude: m.latitude, longitude: m.longitude, content: m.content, limit_days: m.limit_days}
      end
      return data
    end

    desc "喜欢"
    params do
      requires :token, type: String, desc: "token"
      requires :message_id, type: Integer, desc: "message id"
    end
    get "like" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '没有这个用户'} if u.nil?
      m = Message.find_by_id(params[:message_id])
      return {status: 206, message: '留言不存在'} if m.nil?
      m.like_by_user(u)
      return {status: 0}
    end

    desc "取消喜欢"
    params do
      requires :token, type: String, desc: "token"
      requires :message_id, type: Integer, desc: "message id"
    end
    get "cancel_like" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '没有这个用户'} if u.nil?
      m = Message.find_by_id(params[:message_id])
      return {status: 206, message: '留言不存在'} if m.nil?
      m.cancel_like_by_user(u)
      return {status: 0}
    end
    get :ping do
      { data: "pong" }
    end
  end
end
