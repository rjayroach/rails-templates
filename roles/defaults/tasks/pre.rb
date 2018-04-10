
# Common Gemfiles
gem 'dotenv-rails'
gem 'pry-rails'
gem 'awesome_print'

gem_group :development, :test do
  gem 'brakeman', require: false
end

# Project Root files
append_file 'Procfile', "web:    bundle exec rails server -b 0.0.0.0 -p 3000\n"
copy_file 'defaults/files/pryrc', '.pryrc'
template 'defaults/files/tmuxinator.yml', '.tmuxinator.yml'


# Rake task files
# TODO: maybe this should be in dummy_path / @app_dir if it is a plugin
copy_file 'defaults/files/db.rake', 'lib/tasks/db.rake'


# Update to remove rubocop warning
gsub_file "#{app.app_dir}/config/environments/development.rb", "'tmp/caching-dev.txt'", "'tmp', 'caching-dev.txt'"
