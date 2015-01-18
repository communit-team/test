Communit2::Application.routes.draw do

  root to: redirect('/auth/twitter')
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  get 'dashboard', to: 'dashboard#index'

  match 'users/:action', to: 'users#:action', via: 'get'

end
