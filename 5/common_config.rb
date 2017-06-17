
# Common template
remove_file 'Gemfile'
copy_file 'defaults/Gemfile.base', 'Gemfile'

# Common Gemfiles
gem 'dotenv-rails'
gem 'pry-rails'
gem 'awesome_print'

gem_group :development, :test do
  gem 'brakeman', require: false
  gem 'rubocop', require: false
end

# Project Root files
template 'defaults/Procfile', 'Procfile'
copy_file 'defaults/rubocop.yml', '.rubocop.yml'
copy_file 'defaults/pryrc', '.pryrc'
template 'defaults/tmuxinator.yml', '.tmuxinator.yml'

template 'ci/circle.yml', 'circle.yml' if @packages.include?(:circleci)

# Rake task files
# TODO: maybe this should be in dummy_path / @app_dir if it is a plugin
copy_file 'db/db.rake', 'lib/tasks/db.rake'

# Add Rubocop tasks to Rakefile
# insert_into_file 'Rakefile', before: "require_relative 'config/application'\n" do <<-RUBY
append_to_file 'Rakefile' do <<-RUBY
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RUBY
end

# Update to remove rubocop warning
gsub_file "#{@app_dir}/config/environments/development.rb", "'tmp/caching-dev.txt'", "'tmp', 'caching-dev.txt'"
