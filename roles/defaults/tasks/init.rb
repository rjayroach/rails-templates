
# Common Gemfiles
gem 'dotenv-rails'
gem 'pry-rails'
gem 'awesome_print'

gem_group :development, :test do
  gem 'brakeman', require: false
end

app.content_files << 'README.md'

# Project Root files
create_file '.env'
copy_file 'defaults/files/Procfile', 'Procfile'
copy_file 'defaults/files/pryrc', '.pryrc'
template 'defaults/files/tmuxinator.yml', '.tmuxinator.yml'

# Rake task files
# TODO: maybe this should be in dummy_path / @app_dir if it is a plugin
copy_file 'defaults/files/db.rake', 'lib/tasks/db.rake'