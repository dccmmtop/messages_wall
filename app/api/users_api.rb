module Api
  class UsersApi < Grape::API
    format :json

    get :ping do
      { data: "pong" }
    end
  end
end
