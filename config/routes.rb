Rails.application.routes.draw do
  get 'wellcom/wellcom'
  root "wellcom#wellcom"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  mount Api::ApplicationApi => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'
end
