Rails.application.routes.draw do
  root 'pages#index'
  resources :users
  resources :groups
  resources :comments
end
