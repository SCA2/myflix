Myflix::Application.routes.draw do

  root                to: "pages#front"
  get   '/home',      to: 'videos#index'
  get   '/register',  to: 'users#new'
  get   '/sign_in',   to: 'sessions#new'
  post  '/sign_in',   to: 'sessions#create'
  get   '/sign_out',  to: 'sessions#destroy'
  get   '/my_queue',  to: 'queue_items#index'
  post  '/my_queue',  to: 'queue_items#update_queue'
  get   '/people',    to: 'influences#index'

  resources :videos, only: [:index, :show] do
    collection do
      get :search,    to: "videos#search"
      get :advanced_search,    to: "videos#advanced_search"
    end
    resources :reviews, only: :create
  end

  resources :categories,  only: [:show]
  resources :queue_items, only: [:index, :create, :destroy]
  resources :influences,  only: [:create, :destroy]
  resources :webhooks,    only: [:create]

  resources :users, only: [:new, :show, :create, :update] do
    collection do
      get :front,     to: "users#front"
    end
  end

  resources :passwords, only: [:new, :create, :edit, :update]
  get :expired_token, to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end
  
  get 'ui(/:action)', controller: 'ui'

end
