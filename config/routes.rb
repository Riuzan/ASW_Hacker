Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  get 'contributions/index_new', to: 'contributions#index_new'

  resources :sessions, only: [:create, :destroy]
  resources :home, only: [:show]
  resources :contributions
  resources :users
  root 'contributions#index'
end
