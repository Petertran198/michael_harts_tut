Rails.application.routes.draw do
  get 'signup', to: 'users#new'
  root 'static_pages#home'
  get '/contact', to: 'static_pages#contact'
  get  "/explore", to: 'static_pages#explore'
  get  '/about', to: 'static_pages#about'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  #Sessions to login and logout users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get :following, :followers
    end
  end


  resources :account_activations, only: [:edit]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]

end
