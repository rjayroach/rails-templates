gem 'therubyracer'

gem_group :development do
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'rack-livereload'
  gem 'guard-livereload', '~> 2.4', require: false
end

#gsub_file 'Gemfile', /#\s*(filter_parameter_logging :password)/, '\1'

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
#generate :scaffold, 'blog', 'title:string', 'content:string'
#rake 'db:migrate db:test:prepare'
