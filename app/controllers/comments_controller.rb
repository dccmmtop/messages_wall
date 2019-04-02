class CommentsController < ApplicationController
  before_action :login

  def index
    params[:page] ||= 1
    if params[:user_id]
      @comments = Comment.search(params[:filter]).where("user_id = ?",params[:user_id]).order(updated_at: :desc).page(params[:page]).per(10)
    else
      @comments = Comment.search(params[:filter]).order(updated_at: :desc).page(params[:page]).per(10)
    end
  end

  def destroy
    respond_to do |format|
      @comment = Comment.find_by_id(params[:id])
      @comment.destroy
      format.json { render json: {status: 0}}
    end
  end
end
