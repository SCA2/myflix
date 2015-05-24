Myflix::Application.routes.draw do
  get '/home', to: 'videos#index'
  get 'videos/:id', to: 'videos#show'
  get 'ui(/:action)', controller: 'ui'
end
