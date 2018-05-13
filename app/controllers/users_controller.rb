class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:apiEdit]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end
  
  # GET /api/users/1
  # GET /api/users/1.json
  def apiShow
    @user = User.where(["id = ?", params[:id]]).select("id, name, email, about, created_at, updated_at, oauth_token")
    render json: {status: 'SUCCES', message: 'Loaded contributions', data:@user}, status: :ok
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end
  
  

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT/PATCH /api/users/1
  def apiEdit
    key = request.headers["X-API-KEY"]
    @user = User.find(params[:id])
      if @user.token == key
        if  @user.update(user_params)
          render json: {status: 'SUCCES', message: 'User has been updated', data:[]}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Could not update the user', data:[]}, status: :ok
        end
      else 
        render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :ok
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :about, :email)
    end
end
