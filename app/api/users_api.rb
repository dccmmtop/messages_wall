module Api
  class UsersApi < Grape::API
    format :json

    get :ping do
      { data: "pong" }
    end
    desc "获取验证码"
    params do
      requires :email, type: String, desc: "邮箱"
    end
    get :get_validate_code do
      # TODO: 邮箱已经被注册
      UserMailer.validate_code(params[:email]).deliver_now
      {status: 0, message: User.get_validate_code(params[:email])}
    end

    desc "注册"
    params do
      requires :email, type: String, desc: "邮箱"
      requires :name, type: String, desc: "昵称"
      requires :validate_code, type: String, desc: "验证码"
      requires :password, type: String, desc: "密码"
      requires :password_confirmation, type: String, desc: "重复密码"
    end
    post :regist_user do
      if params[:validate_code].nil? || params[:validate_code].strip.size == 0 || User.get_validate_code(params[:email]) != params[:validate_code]
        return {status: 102, message: "验证码错误"}
      else
        @user = User.new(email: params[:email],nickname: params[:name],password: params[:password], password_confirmation: params[:password_confirmation],admin: false)
        if @user.save
          return {status: 0, message: "注册成功"}
        else
          return {status: 103, message: @user.errors.full_messages.join(",")}
        end
      end
    end

    desc "登录"
    params do
      requires :email_name, type: String, desc: "邮箱或者用户名"
      requires :password, type: String, desc: "密码"
    end
    post :login do
      email_name = params[:email_name]
      @user = User.find_by_nickname(email_name) || User.find_by_email(email_name)
      return {status: 104, message: "用户不存在"} unless @user
      return {status: 105, message: "密码错误"} unless @user.authenticate(params[:password])
      @user.regenerate_token
      return {status: 0, token: @user.token, nickname: @user.nickname, email: @user.email, avatar: @user.avatar.url.gsub("public")}
    end

    desc "修改昵称"
    params do
      requires :token, type: String, desc: "token"
      requires :nickname, type: String, desc: "新的昵称"
    end
    get :update_nickname do
      @user = User.find_by_token(params[:token])
      if @user
        if @user.update(nickname: params[:nickname])
          return {status: 0, message: '更新成功'}
        else
          return {status: 107, message: @user.errors.full_messages.join(",")}
        end
      else
        return {status: 106, message: "用户不存在"}
      end
    end

    desc "修改密码"
    params do
      requires :token, type: String, desc: "token"
      requires :old_password, type: String, desc: "旧密码"
      requires :password, type: String, desc: "新密码"
      requires :password_confirmation, type: String, desc: "重复密码"
    end
    post :update_password do
      @user = User.find_by_token(params[:token])
      return {status: 106, message: "用户不存在"} if @user.nil?
      return {status: 108, message: "密码错误"} unless @user.authenticate(params[:old_password])
      if @user.update(password: params[:password],password_confirmation: params[:password_confirmation])
        return {status: 0, message: '更新成功'}
      else
        return {status: 109, message: @user.errors.full_messages.join(",")}
      end
    end

    desc "修改头像"
    params do
      requires :token, type: String, desc: "token"
      requires :avatar, type: File, desc: "图片"
    end
    post :update_avatar do
      @user = User.find_by_token(params[:token])
      return {status: 106, message: "用户不存在"} if @user.nil?
      @user.avatar = params[:avatar]
      if @user.save
        return {status: 0, message: '更新成功'}
      else
        return {status: 110, message: @user.errors.full_messages.join(",")}
      end
    end
  end
end
