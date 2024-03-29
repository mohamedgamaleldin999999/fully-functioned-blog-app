class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = params[:post_id]
    if @comment.save
      redirect_to user_post_path(params[:user_id], params[:post_id])
    else
      render :new
    end
  end

  def destroy
    puts params
    @comment = Comment.find(params[:comment_id])

    authorize! :destroy, @comment

    if @comment.destroy
      redirect_to user_post_path(params[:user_id], params[:post_id]), notice: 'Comment deleted successfully.'
    else
      flash[:alert] = 'Failed to delete the comment.'
      render :show
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
