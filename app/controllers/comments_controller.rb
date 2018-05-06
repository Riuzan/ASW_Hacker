class CommentsController < ApplicationController
include SessionsHelper
before_action :find_commentable

  def show
    @comment = Comment.find(params[:id])
    @contribution = Contribution.find(params[:contribution_id])
  end

  def new
   @comment = Comment.new
  end
    
  def create
    @contribution = Contribution.find_by_id(params[:contribution_id])
    @comment = @commentable.comments.new comment_params
    if is_logged_in?
      @comment.user_id = current_user.id
    end
    #respond_to do |format|
      if @comment.save
        #redirect_back fallback_location: root_path, notice: 'Your comment was successfully posted!'
        #format.html { redirect_back fallback_location: root_path, notice: 'Contribution was successfully created.' }
        #format.json { render :show, status: :created, location: @comment }
        redirect_to @contribution
      else
        #format.html { render :new }
        #format.json { render json: @comment.errors, status: :unprocessable_entity }
        redirect_to @contribution
      end
    #end
  end
  
  def upvote 
    @comment = Comment.find(params[:id])
    @comment.liked_by current_user
    redirect_back(fallback_location: root_path)
  end  

  def unvote
    @comment = Comment.find(params[:id])
    @comment.unliked_by current_user
     redirect_back(fallback_location: root_path)
  end
  
  
  private

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

  def find_commentable
    @commentable = Contribution.find_by_id(params[:contribution_id]) if params[:contribution_id]
    @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
  end

end