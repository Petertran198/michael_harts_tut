Rails.application.routes.draw do
  get 'signup', to: 'users#new'
  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'
  get  "/help", to: 'static_pages#help'
  get  '/about', to: 'static_pages#about'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  #Sessions to login and logout users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :account_activations, only: [:edit]
  resources :microposts,          only: [:create, :destroy]

end
