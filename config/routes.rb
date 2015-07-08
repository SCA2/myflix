Myflix::Application.routes.draw do

  root                to: "pages#front"
  get   '/home',      to: 'videos#index'
  get   '/register',  to: 'users#new'
  get   '/sign_in',   to: 'sessions#new'
  post  '/sign_in',   to: 'sessions#create'
  get   '/sign_out',  to: 'sessions#destroy'
  get   '/my_queue',  to: 'queue_items#index'
  post  '/my_queue',  to: 'queue_items#update_queue'
  
  resources :videos, only: [:index, :show] do
    collection do
      get :search,    to: "videos#search"
    end
    resources :reviews, only: :create
  end

  resources :categories, only: :show
  resources :queue_items, only: [:index, :create, :destroy]
  resources :influences, only: [:index, :create, :destroy]

  resources :users, only: [:new, :show, :create, :update] do
    collection do
      get :front,     to: "users#front"
    end
  end

  get 'ui(/:action)', controller: 'ui'

end
