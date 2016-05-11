Rails.application.routes.draw do
  resources :advisories, only: [:show]
  resources :server, only: [:show]
  resources :ossec, only: [:index, :show]
  resources :puppet, only: [:index]

  get '/summary/index'
  root 'summary#index'
end
