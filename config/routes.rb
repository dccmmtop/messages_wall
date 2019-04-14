Rails.application.routes.draw do

  root "sessions#new"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy"

  resources :messages
  resources :comments
  resources :notifications

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  mount Api::ApplicationApi => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'
end
