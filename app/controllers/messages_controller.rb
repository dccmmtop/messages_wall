class MessagesController < ApplicationController
  before_action :login
  def index
    params[:page] ||= 1
    if params[:user_id]
      @messages = Message.search(params[:filter]).where("user_id = ?",params[:user_id]).order(updated_at: :desc).page(params[:page]).per(10)
    else
      @messages = Message.search(params[:filter]).order(updated_at: :desc).page(params[:page]).per(10)
    end
  end

  def show
    @message = Message.find_by_id(params[:id])
    @comments = @message.comments.order(created_at: :desc)
  end

  def destroy
    respond_to do |format|
      @message = Message.find_by_id(params[:id])
      @message.destroy
      format.json { render json: {status: 0}}
      format.html { redirect_to :messages, notice: "删除成功！"}
    end
  end
end
