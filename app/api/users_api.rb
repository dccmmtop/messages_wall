module Api
  class UsersApi < Grape::API
    format :json

    get :ping do
      { data: "pong" }
    end

    params do
      requires :email, type: String, desc: "邮箱"
    end
    get :get_validate_code do
      # TODO: 邮箱已经被注册
      UserMailer.validate_code(params[:email]).deliver_now
      {status: 0, message: User.get_validate_code(params[:email])}
    end

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
      return {status: 0, token: @user.token, nickname: @user.nickname, email: @user.email}
    end
  end
end
