Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  get 'contributions/index_new', to: 'contributions#index_new'
  get '/reply' => 'contributions#reply'
  get "contributions/ask" => "contributions#ask"
  
  get 'contributions/comments/reply', to: 'comments#reply'
  
  resources :sessions, only: [:create, :destroy]
  resources :home, only: [:show]
  resources :contributions do 
      member do
        put "upvote", to: "contributions#upvote"
        put "unvote", to: "contributions#unvote"
        resources :comments
    end
  end
  
  resources :comments do
    resources :comments
  end
  
  resources :users
  root 'contributions#index'
end
