Rails.application.routes.draw do
  root   'home#index'
  get    'auth'             => 'home#auth'

  post   '/login'           => 'user_token#create'

  get    '/user'            => 'users#show'
  post   '/user'            => 'users#create'
  patch  '/user/:id'        => 'users#update'
  delete '/user/:id'        => 'users#destroy'

  get '/user/park_spots'    => 'park_spots#park_spots_for_user'

  resource :park_spot
end
