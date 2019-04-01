class CommentsController < ApplicationController

  def destroy
    respond_to do |format|
      @comment = Comment.find_by_id(params[:id])
      @comment.destroy
      format.json { render json: {status: 0}}
    end
  end
end
