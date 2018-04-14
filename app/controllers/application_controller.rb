class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def current_user
    @current_user ||= User.find(1)
  end
helper_method :current_user

#En aquesta etapa suposem que esta loguejat, pero en les seguents ens ajudara el que hem declarat previament.

end
