Myflix::Application.routes.draw do

  root                to: "pages#front"
  get   '/home',      to: 'videos#index'
  get   '/register',  to: 'users#new'
  get   '/sign_in',   to: 'sessions#new'
  post  '/sign_in',   to: 'sessions#create'
  get   '/sign_out',  to: 'sessions#destroy'
  
  resources :videos, only: [:index, :show] do
    collection do
      get :search,    to: "videos#search"
    end
  end

  resources :categories, only: :show

  resources :users, only: [:new, :create] do
    collection do
      get :front,     to: "users#front"
    end
  end

  get 'ui(/:action)', controller: 'ui'

end
