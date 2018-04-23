class ContributionsController < ApplicationController
  include SessionsHelper
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]
  
  
  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.all
  end
  
  def index_new
    @contributions = Contribution.all
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
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

  # POST /contributions
  # POST /contributions.json
  def create

    @contribution = Contribution.new(contribution_params)

    if is_logged_in?
      @contribution.user_id = current_user.id
    end
    respond_to do |format|
      if @contribution.title != nil && @contribution.save  #es post
        format.html { redirect_to @contribution, notice: 'Contribution was successfully created.' }
        format.json { render :show, status: :created, location: @contribution }
      elsif @contribution.title == nil && Contribution.find(@contribution.comment_id).title != nil && @contribution.save   #es un comentari d'un  post
        @aux = Contribution.find(@contribution.comment_id)
        @aux.totalComments = @aux.totalComments + 1
        @aux.save
        format.html { redirect_to Contribution.find(@contribution.comment_id), notice: 'Contribution was successfully created.' }
        format.json { render :show, status: :created, location: @contribution }
      elsif @contribution.title == nil && Contribution.find(@contribution.comment_id).title == nil && @contribution.save ##es un reply d'un comentari
        @aux = Contribution.find(Contribution.find(@contribution.comment_id).comment_id)
        @aux.totalComments = @aux.totalComments + 1
        @aux.save
        format.html { redirect_to Contribution.find(Contribution.find(@contribution.comment_id).comment_id), notice: 'Contribution was successfully created.' }
        format.json { render :show, status: :created, location: @contribution }
      else
        format.html { render :new }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
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
      format.html { redirect_to contributions_url, notice: 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params.require(:contribution).permit(:title, :url, :text, :votes, :user_id)
    end
end
