Rails.application.routes.draw do
  root   'home#index'
  get    'auth'            => 'home#auth'

  post   '/login'          => 'user_token#create'

  get    '/user'           => 'users#current'
  post   '/user'           => 'users#create'
  patch  '/user/:id'       => 'users#update'
  delete '/user/:id'       => 'users#destroy'

  resource :park_spots
end
