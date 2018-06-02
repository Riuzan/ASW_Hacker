class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :cors_set_access_control_headers
  
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    #@current_user ||= User.find(1)
  end
end

def cors_set_access_control_headers
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
  headers['Access-Control-Request-Method'] = '*'
  headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
end