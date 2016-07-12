Rails.application.routes.draw do
  get 'search/search'

  # Root path
  root to: 'pages#index'

  # Token authentication
  mount_devise_token_auth_for 'User', at: 'auth'

  # ProductsController
  resources :products, only: [ :index, :create, :show ]

  # MessagesController
  get 'messages/check/:since', to: 'messages#check', as: 'check_messages'
  post 'messages/send_to/:user_id', to: 'messages#send_to', as: 'send_message_to_user'

  # SearchController
  get 'search/:scope/:query', to: 'search#search', as: 'search'

  # UsersController
  resources :users, only: [ :show ]

end
