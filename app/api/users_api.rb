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
      UserMailer.validate_code(params[:email]).deliver_now
    end
  end
end
