Rails.application.routes.draw do
  resources :contributions
  resources :users
  #root 'users#index'
  root 'contributions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
