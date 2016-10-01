# See: https://www.sitepoint.com/rails-application-templates-real-world/

def source_paths
  c_dir = File.expand_path(File.dirname(__FILE__))
  Array(super) + [c_dir, File.join(c_dir, '..'), File.join(c_dir, '../../files')]
end


# Common template
apply('common.rb')

# apply('api-gems.rb') # Create Gemfile from scratch
apply('pg.rb')       # config/database.yml
apply('cors.rb')     # config/initializers/cors.rb

# JR directory
empty_directory 'app/resources'

# Project Root files
remove_file 'Gemfile'
copy_file 'Gemfile.api', 'Gemfile'
copy_file 'Guardfile'
copy_file 'Procfile'
copy_file 'rubocop.yml', '.rubocop.yml'
copy_file 'pryrc', '.pryrc'
template 'circle.yml', 'circle.yml'

# Rake task files
copy_file 'db.rake', 'lib/tasks/db.rake'

remove_dir 'test'

after_bundle do
  application do <<-RUBY
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.template_engine false
      g.routing_specs false
    end

  RUBY
  end

  run 'spring stop'
  generate 'rspec:install'

  insert_into_file 'app/controllers/application_controller.rb', after: "ActionController::API\n" do <<-RUBY
  include JSONAPI::ActsAsResourceController

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # NOTE: This throws an exception:
  # protect_from_forgery with: :null_session
  RUBY
  end


  # Health Check route
  # generate(:controller, 'health index')
  # route "root to: 'health#index'"

  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end
