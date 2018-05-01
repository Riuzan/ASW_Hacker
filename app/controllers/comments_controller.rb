class CommentsController < ApplicationController
include SessionsHelper
before_action :find_commentable

    def show
      @comment = Comment.find(params[:id])
    end

    def new
      @comment = Comment.new
    end

    def create
      @comment = @commentable.comments.new comment_params
      if is_logged_in?
        @comment.user_id = current_user.id
      end
      respond_to do |format|
        if @comment.save
          #redirect_back fallback_location: root_path, notice: 'Your comment was successfully posted!'
          format.html { redirect_back fallback_location: root_path, notice: 'Contribution was successfully created.' }
          format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:body, :user_id)
    end

    def find_commentable
      @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
      @commentable = Contribution.find_by_id(params[:id]) if params[:id]
      @father = Contribution.find_by_id(params[:id]) if params[:id]
    end

end