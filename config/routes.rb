Rails.application.routes.draw do
  # Root path
  root to: 'pages#index'

  # Token authentication
  mount_devise_token_auth_for 'User', at: 'auth'

  # ProductsController
  resources :products, only: [ :index, :show ]
end
