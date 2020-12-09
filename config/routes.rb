Rails.application.routes.draw do
  resources :server, only: [:show]
  resources :systems, only: [:index]
  resources :software, only: [:index]
  resources :sources, only: [:index]

  get '/summary/index'
  root 'summary#index'
end
