app.gem 'jsonapi-resources', '0.10.0.beta1'
app.gem 'rails-html-sanitizer'

# JR directory
empty_directory 'app/resources'

# Initializers
copy_file 'jsonapi/files/jsonapi_resources.rb', 'config/initializers/jsonapi_resources.rb'

# Have ApplicationController include JSONAPI::ResourceController
insert_into_file "#{app.controllers_path}/application_controller.rb", after: "ActionController::API\n" do <<-RUBY
  include JSONAPI::ActsAsResourceController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # NOTE: This throws an exception:
  # protect_from_forgery with: :null_session
  RUBY
end

# Health Check routes
route "root to: 'health#index'"
route "get 'index', to: 'health#index'"

template 'jsonapi/files/health_controller.rb', "#{app.controllers_path}/health_controller.rb"
