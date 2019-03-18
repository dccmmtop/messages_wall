module Api
  class CommentsApi < Grape::API
    format :json

    desc "create comments"
    params do
      requires :token, type: String, desc: "token"
      requires :content, type: String, desc: "comment content"
      requires :message_id, type: Integer, desc: "message id"
    end
    post "create" do 
      @user = User.find_by_token(params[:token])
      return {status:200,message:'没有找到该用户'} if @user.nil?
      @comment = Comment.new(user_id: @user.id, body: params[:content], message_id: params[:message_id])
      if @comment.save
        return {status: 0, message: "评论成功",comment:{"id-#{@comment.id}" => {user: {nickname: @comment.user.nickname, avatar: @comment.user.avatar.url.gsub("public","")},id: "id-#{@comment.id}",content: @comment.body, liked: false, published_at: @comment.created_at.strftime( "%Y-%m-%d %H:%M")}}}
      else
        return {status: 301, message: @comment.errors.full_messages.join(',')}
      end
    end

    desc "查看某条留言的评论"
    params do
      requires :id, type: Integer, desc: "留言id"
      requires :page, type: Integer, desc: "分页"
      requires :token, type: String, desc: "token"
    end
    get "get_messages_comments_by_id" do
      m = Message.find_by_id(params[:id])
      u = User.find_by_token(params[:token])
      if m
        @comments = m.comments.order(created_at: :desc).page(params[:page]).per(5)
        res = {status: 0,comments:{},counts: m.comments.count, total_pages: @comments.total_pages}
        @comments.each do |com|
          res[:comments].merge!("id-#{com.id}" => {user: {nickname: com.user.nickname, avatar: com.user.avatar.url.gsub("public","") + "?time=#{u.updated_at.to_i}"},id: "id-#{com.id}",content: com.body, liked: com.liked_by_user?(u), published_at: com.created_at.strftime( "%Y-%m-%d %H:%M")})
        end
        return res
      else
        return {status: 202, message: '没有找到留言'}
      end
    end

    desc "喜欢"
    params do
      requires :token, type: String, desc: "token"
      requires :comment_id, type: Integer, desc: "comment id"
    end
    get "like" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '没有这个用户'} if u.nil?
      com = Comment.find_by_id(params[:comment_id])
      return {status: 206, message: '评论不存在'} if com.nil?
      com.like_by_user(u)
      return {status: 0}
    end

    desc "取消喜欢"
    params do
      requires :token, type: String, desc: "token"
      requires :comment_id, type: Integer, desc: "comment id"
    end
    get "cancel_like" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '没有这个用户'} if u.nil?
      com = Comment.find_by_id(params[:comment_id])
      return {status: 206, message: '评论不存在'} if com.nil?
      com.cancel_like_by_user(u)
      return {status: 0}
    end

    desc "删除评论"
    params do
      requires :token, type: String, desc: "token"
      requires :id, type: Integer, desc: "评论id"
    end
    post "delete" do
      u = User.find_by_token(params[:token])
      return {status: 205, message: '删除失败，没有该用户'} if u.nil?
      com = Comment.find_by("id = ?",params[:id])
      if com && (com.user.token == params[:token] || com.message.user.token == params[:token])
        com.delete
        return {status: 0,message: "删除成功"}
      else
        return {status: 302, message: '删除失败'}
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
