Rails.application.routes.draw do

  resources :advisories, only: [:show]
  resources :ossec, only: [:index, :show]

  get '/summary/index'
  root 'summary#index'

end
