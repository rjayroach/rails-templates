# See: https://www.sitepoint.com/rails-application-templates-real-world/

def source_paths
  c_dir = File.expand_path(File.dirname(__FILE__))
  Array(super) + [c_dir, File.join(c_dir, '..'), File.join(c_dir, '../../files')]
end


# Common template
apply('common.rb')
git :init

# apply('api-gems.rb') # Create Gemfile from scratch
apply('pg.rb')       # config/database.yml
apply('cors.rb')     # config/initializers/cors.rb
apply('guard.rb')    # Guardfile

# JR directory
empty_directory 'app/resources'

# Project Root files
remove_file 'Gemfile'
copy_file 'Gemfile.api', 'Gemfile'
copy_file 'Procfile'
copy_file 'rubocop.yml', '.rubocop.yml'
copy_file 'pryrc', '.pryrc'
template 'circle.yml', 'circle.yml'

# Rake task files
copy_file 'db.rake', 'lib/tasks/db.rake'

# Initializers
copy_file 'jsonapi_resources.rb', 'config/initializers/jsonapi_resources.rb'


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
  apply('rspec.rb')    # spec/rails_helper.rb
  apply('controllers.rb')
  apply('git.rb')
end
