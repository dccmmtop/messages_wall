Rails.application.routes.draw do

  get 'users/index'

  resources :messages

  root "sessions#new"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#delete"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  mount Api::ApplicationApi => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'
end
