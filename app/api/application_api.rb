require 'grape-swagger'
module Api
  class ApplicationApi < Grape::API

    GrapeSwaggerRails.options.url = '/api/swagger_doc'
    GrapeSwaggerRails.options.before_action do
      GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
    end
    GrapeSwaggerRails.options.doc_expansion = 'list'
    GrapeSwaggerRails.options.hide_api_key_input = true

    mount Api::MessagesApi => '/messages'
    mount Api::UsersApi => '/users'
    add_swagger_documentation
  end
end
