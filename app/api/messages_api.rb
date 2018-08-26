module Api
  class MessagesApi < Grape::API
    format :json
    desc "create message"

    params do
      requires :ime, type: String, desc: "pone IME"
      requires :content, type: String, desc: "message content"
      requires :position, type: String, desc: "position"
      requires :limit_user_account, type: Integer, desc: "观看人数限制"
      requires :limit_days, type: Integer, desc: "时间限制"
    end
    post "create" do 
      user = User.find_by_ime(params[:ime].strip)
      if user.nil?
        return {status:1,message:'not found user',data:{}}
      end
    end
    get :ping do
      { data: "pong" }
    end
  end
end
