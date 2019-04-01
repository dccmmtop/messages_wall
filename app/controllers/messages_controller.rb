class MessagesController < ApplicationController
  def index
    params[:page] ||= 1
    @messages = Message.search(params[:filter]).page(params[:page]).per(2)
  end

  def show
    @message = Message.find_by_id(params[:id])
    @comments = @message.comments
  end
end
