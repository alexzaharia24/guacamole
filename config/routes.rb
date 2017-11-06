Rails.application.routes.draw do
  root    'home#index'
  get     'auth'              => 'home#auth'

  post    '/login'            => 'user_token#create'

  get     '/user'             => 'users#show'
  post    '/user'             => 'users#create'
  patch   '/user/:id'         => 'users#update'
  put     '/user/:id'         => 'users#update'
  delete  '/user/:id'         => 'users#destroy'

  get     '/user/park_spots'  => 'park_spots#park_spots_for_user'

  get     '/park_spot/:id'    => 'park_spots#show'
  patch   '/park_spot/:id'    => 'park_spots#update'
  put     '/park_spot/:id'    => 'park_spots#update'
  delete  '/park_spot/:id'    => 'park_spots#destroy'
  post    '/park_spot'        => 'park_spots#create'

  get     '/availability/:id' => 'availabilities#show'
  patch   '/availability/:id' => 'availabilities#update'
  put     '/availability/:id' => 'availabilities#update'
  delete  '/availability/:id' => 'availabilities#destroy'
  post    '/availability'     => 'availabilities#create'
end
