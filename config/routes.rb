Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  
  get 'contributions/index_new', to: 'contributions#index_new'
  get '/reply' => 'contributions#reply'
  get "contributions/ask" => "contributions#ask"
  get "comments/threads" => "comments#threads"
  get 'contributions/comments/reply', to: 'comments#reply'
  
  resources :sessions, only: [:create, :destroy]
  resources :home, only: [:show]
  resources :contributions do 
    resources :comments
    member do
      put "upvote", to: "contributions#upvote"
      put "unvote", to: "contributions#unvote"
    end
  end
  
  resources :comments do
    resources :comments
    member do
      put "upvote", to: "comments#upvote"
      put "unvote", to: "comments#unvote"
    end
  end
  
  namespace :api do 
      get "users/:id", to: "/users#apiShow"
      put "users/:id", to: "/users#apiEdit"
      patch "users/:id", to: "/users#apiEdit"
      post "users/:id/contributions/ask", to: "/contributions#apiCreateAsk"
      post "users/:id/contributions/url", to: "/contributions#apiCreateUrl"
      post "users/:id/contributions/:commentable_id/comments", to: "/comments#apiCreate"
      post "users/:id/comments/:commentable_id/reply", to: "/comments#apiCreateReply"
      put "users/:id/comments/:idc/upvote", to: "/comments#apiUpvote"
      put "users/:id/comments/:idc/unvote", to: "/comments#apiUnvote"
      put "users/:id/contributions/:idc/upvote", to: "/contributions#apiUpvote"
      put "users/:id/contributions/:idc/unvote", to: "/contributions#apiUnvote"
      get "contributions/new", to: "/contributions#apiGetNew"
      get "contributions/ask", to: "/contributions#apiGetAsk"
      get "contributions/url", to: "/contributions#apiGetUrl"
      get "contributions/:id", to: "/contributions#apiGetContribution"
      get "users/:id/threads", to: "/comments#apiThreads"
      get "contributions/:id/comments", to: "/contributions#apiGetComments"
      delete "contributions/:id", to: "/contributions#apiDelete"
      delete "comments/:id", to: "/comments#apiDelete"
  end
  resources :users
  root 'contributions#index'
end
