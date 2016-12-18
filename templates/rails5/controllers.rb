# Have ApplicationController include JSONAPI::ResourceController
insert_into_file 'app/controllers/application_controller.rb', after: "ActionController::API\n" do <<-RUBY
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

copy_file('health_controller.rb', 'app/controllers/health_controller.rb')
