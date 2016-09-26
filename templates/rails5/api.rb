def source_paths
  c_dir = File.expand_path(File.dirname(__FILE__))
  Array(super) + [File.join(c_dir, '..'), File.join(c_dir, '../../files')]
end


# Common template
apply('common.rb')

gem 'pry-rails'
gem 'awesome_print'
gem 'pg'
gem 'jsonapi-resources'

gem_group :development do
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'database_cleaner'
end

gem_group :development do
  gem 'guard-rspec', require: false
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-ctags-bundler', require: false
  gem 'guard-rubocop', require: false
  gem 'brakeman', '~> 3.0', require: false
  gem 'guard-brakeman', require: false
  gem 'rubocop', require: false
end

# remove all comments from Gemfile
gsub_file 'Gemfile', /#.*$/, ''
# remove not needed gems
gsub_file 'Gemfile', /gem 'sqlite3'/, ''
gsub_file 'Gemfile', /gem tzinfo-data.*$/, ''


copy_file 'Guardfile'
copy_file 'Procfile'
template 'circle.yml', 'circle.yml'
copy_file 'rubocop.yml', '.rubocop.yml'
