class ContributionsController < ApplicationController
  include SessionsHelper
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]
  before_action :auth_token, only: [:apiCreateASk,:apiCreateUrl, :apiUpvote, :apiUnvote, :apiDelete]
  skip_before_action :verify_authenticity_token, only: [:apiVotedByCurrentUser, :apiCreateAsk,:apiCreateUrl, :apiUpvote, :apiUnvote, :apiGetNew, :apiGetAsk, :apiGetUrl, :apiGetContribution, :apiGetComments, :apiDelete]

  
  
  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.select{ |c| c.url != nil}.sort { |x,y| y.get_likes.size <=> x.get_likes.size }.first(30)
  end
  
  def index_new
    @contributions = Contribution.all.order(created_at: :DESC).first(30)
  end


  # GET /contributions/1
  # GET /contributions/1.json
  def show
    #@contributions = Contribution.all
    @contribution = Contribution.find(params[:id])
  end
  
  def ask
    @contributions = Contribution.all.order(created_at: :DESC).select{ |c| c.url == nil}.first(30)
  end

  # GET /contributions/new
  def new
    unless is_logged_in?
      redirect_to signin_path('google')
      return
    end
    @contribution = Contribution.new
  end

  # GET /contributions/1/edit
  def edit
  end

  def apiGetNew
    @contributions = Contribution.all.order(created_at: :DESC).first(30)
    render json: {status: 'SUCCESS', message: 'Contributions ordered by new', data: @contributions}, status: :ok
  end
  
  def apiGetAsk
    @contributions = Contribution.all.order(created_at: :DESC).select{ |c| c.url == nil}.first(30)
    render json: {status: 'SUCCESS', message: 'Contributions ask', data: @contributions}, status: :ok
  end
  
  def apiGetUrl
    @contributions = Contribution.select{ |c| c.url != nil}.sort { |x,y| y.get_likes.size <=> x.get_likes.size }.first(30)
    render json: {status: 'SUCCESS', message: 'Contributions url', data: @contributions}, status: :ok
  end
  
  def apiGetContribution
    @contributions = Contribution.find(params[:id])
    render json: {status: 'SUCCESS', message: 'Contributions found', data: @contributions}, status: :ok
  end
  
  def apiGetComments
    @contributions = Comment.select{ |c| c.commentable_id == params[:id].to_i and c.commentable_type == "Contribution"}
    render json: {status: 'SUCCESS', message: 'Comments found', data: @contributions}, status: :ok
  end
  
  def apiVotedByCurrentUser
       @contribution = Contribution.find(params[:id])
       @aux = current_user.liked? @contribution
      render json: {status: 'SUCCESS', message: 'Comments found', data: @aux}, status: :ok
  end
  
  # POST /contributions
  # POST /contributions.json
  def create

    @contribution = Contribution.new(contribution_params)

    if is_logged_in?
      @contribution.user_id = current_user.id
      @contribution.username = current_user.name
    end
    respond_to do |format|
      if @contribution.url == ""
        @contribution.url = nil
      end
      if @contribution.title != nil && @contribution.save  #es post
        format.html { redirect_to "/contributions/index_new"}
        format.json { render :show, status: :created, location: @contribution }
      elsif @contribution.title == nil && @contribution.comment_id != nil && @contribution.save   #es un comentari o un reply d'un  post
        @aux = Contribution.find(@contribution.comment_id)
        @aux.total_Comments ||= 0
        @aux.total_Comments = @aux.total_Comments + 1
        @aux.save
        format.html { redirect_to Contribution.find(@contribution.comment_id)}
        format.json { render :show, status: :created, location: @contribution }
      else
        format.html { render :new }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /api/users/:id/contributions/ask
  def apiCreateAsk

    @contribution = Contribution.new(params.permit(:title, :text))
    @contribution.user_id = params[:id]
    @contribution.url = nil
      if @contribution.title != nil && @contribution.save  #es post
         render json: {status: 'SUCCES', message: 'Post saved', data: @contribution}, status: :ok
      else
       
        render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error
      end
  end
  
  
  # POST /api/users/:id/contributions/url
  def apiCreateUrl

    @contribution = Contribution.new(params.permit(:title, :url))
    @contribution.user_id = params[:id]
    @contribution.text = nil
      if @contribution.title != nil && @contribution.save  #es post
         render json: {status: 'SUCCES', message: 'Post saved', data: @contribution}, status: :ok
      else
       
        render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error
      end
  end
  
  

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url }
      format.json { head :no_content }
    end
  end
  
  # DELETE /api/contributions/1
  # DELETE /api/contributions/1.json
  def apiDelete
    @contribution = Contribution.find(params[:idc])
    @contribution.destroy
  end

def upvote 
  @contribution = Contribution.find(params[:id])
  if not current_user.liked? @contribution
    @contribution.liked_by current_user
    @contribution.increment!(:votes, 1)
    redirect_back(fallback_location: root_path)
  end
end  

def unvote
  @contribution = Contribution.find(params[:id])
  if current_user.liked? @contribution
     @contribution.unliked_by current_user
     @contribution.decrement!(:votes, 1)
     redirect_back(fallback_location: root_path)
  end
end

def apiUpvote 
    @user = User.find(params[:id])
    if @user == nil 
      render json: {status: 'ERROR', message: 'User does not exist', data: []}, status: :internal_server_error
    end
    @contribution = Contribution.find(params[:idc])
    if @contribution == nil 
      render json: {status: 'ERROR', message: 'Contribution does not exist', data: []}, status: :internal_server_error
    end
    @contribution.liked_by @user
    render json: {status: 'SUCCESS', message: 'Contribution upvoted', data: []}, status: :ok
end  
  
  def apiUnvote
    @user = User.find(params[:id])
    if @user == nil 
      render json: {status: 'ERROR', message: 'User does not exist', data: []}, status: :internal_server_error
    end
    @contribution = Contribution.find(params[:idc])
    if @contribution == nil 
      render json: {status: 'ERROR', message: 'Contribution does not exist', data: []}, status: :internal_server_error
    end
    @contribution.unliked_by @user
    render json: {status: 'SUCCESS', message: 'Contribution unvoted', data: []}, status: :ok
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params.require(:contribution).permit(:title, :url, :text,:votes, :user_id, :comment_id)
    end
    
    def auth_token
      key = request.headers["X-API-KEY"]
      @user = User.find(params[:id])
      if @user.token != key
        render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
      end
    end
      
    
  
end