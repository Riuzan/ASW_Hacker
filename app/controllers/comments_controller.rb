class CommentsController < ApplicationController
include SessionsHelper
before_action :find_commentable
before_action :auth_token, only: [:apiCreate, :apiCreateReply, :apiUpvote, :apiUnvote]
skip_before_action :verify_authenticity_token, only: [:apiCreate, :apiCreateReply, :apiUpvote, :apiUnvote]

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
  
  
  def apiCreate
    @comment = @commentable.comments.new params.require(:comment).permit(:body)
    @comment.commentable_type = "Contribution"
    @comment.commentable_id = params[:commentable_id]
    @comment.user_id = params[:id]

      if @comment.save
        render json: {status: 'SUCCESS', message: 'Comment saved', data: @comment}, status: :ok

      else
        render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error

      end
  end
  
  def apiCreateReply
    @comment = @commentable.comments.new params.require(:comment).permit(:body)
    @comment.commentable_type = "Comment"
    @comment.commentable_id = params[:commentable_id]
    @comment.user_id = params[:id]

      if @comment.save
        render json: {status: 'SUCCESS', message: 'Comment saved', data: @comment}, status: :ok

      else
        render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error

      end
  end
  
   def apiThreads
     
    @comment = Comment.select{ |c| c.user_id == params[:id].to_i}
        render json: {status: 'SUCCESS', message: 'Comments from user', data: @comment}, status: :ok
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
  
  def apiUpvote 
    @user = User.find(params[:id])
    if @user == nil 
      render json: {status: 'ERROR', message: 'User does not exist', data: []}, status: :internal_server_error
    end
    @comment = Comment.find(params[:idc])
    if @comment == nil 
      render json: {status: 'ERROR', message: 'Comment does not exist', data: []}, status: :internal_server_error
    end
    @comment.liked_by @user
    render json: {status: 'SUCCESS', message: 'Comment upvoted', data: []}, status: :ok
  end  
  
  def apiUnvote
    @user = User.find(params[:id])
    if @user == nil 
      render json: {status: 'ERROR', message: 'User does not exist', data: []}, status: :internal_server_error
    end
    @comment = Comment.find(params[:idc])
    if @comment == nil 
      render json: {status: 'ERROR', message: 'Comment does not exist', data: []}, status: :internal_server_error
    end
    @comment.unliked_by @user
     render json: {status: 'SUCCESS', message: 'Comment unvoted', data: []}, status: :ok
  end
  

  
  
  private

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

  def find_commentable
    @commentable = Contribution.find_by_id(params[:commentable_id]) if params[:commentable_id]
    if(params[:commentable_id] && @commentable == nil)
      @commentable = Comment.find_by_id(params[:commentable_id])
    end
  end
  
  def auth_token
      key = request.headers["X-API-KEY"]
      @user = User.find(params[:id])
      if @user.token != key
        render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
      end
  end

end