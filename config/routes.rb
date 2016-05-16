Rails.application.routes.draw do
  resources :advisories, only: [:show]
  resources :server, only: [:show]
  resources :ossec, only: [:index, :show]
  resources :systems, only: [:index]
  resources :software, only: [:index]

  get '/summary/index'
  root 'summary#index'
end
