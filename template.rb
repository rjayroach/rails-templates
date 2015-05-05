gem 'therubyracer'

gem_group :development do
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'rack-livereload'
  gem 'guard-livereload', '~> 2.4', require: false
end

# Remove turbolinks
gsub_file 'Gemfile', /gem 'turbolinks'/, ''
gsub_file 'app/assets/javascripts/application.js', /\/\/= require turbolinks/, ''

# Run livereload in development
inject_into_file 'config/environments/development.rb', "  config.middleware.use Rack::LiveReload\n", after: "Rails.application.configure do\n"

def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'files')]
end

copy_file 'Guardfile'
copy_file 'Procfile'

after_bundle do
  git :init
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
  run 'bundle exec rails g rspec:install'
  run 'rm -rf test'
end

# Remove after testing
generate :scaffold, 'blog', 'title:string', 'content:string'
rake 'db:migrate db:test:prepare'
