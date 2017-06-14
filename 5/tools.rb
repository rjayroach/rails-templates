
gem_group :development, :test do
  gem 'brakeman', require: false
  gem 'rubocop', require: false
end

# Project Root files
copy_file 'Procfile'
copy_file 'rubocop.yml', '.rubocop.yml'
copy_file 'pryrc', '.pryrc'
template 'circle.yml', 'circle.yml'
template 'tmuxinator.yml', '.tmuxinator.yml'

# Rake task files
copy_file 'db.rake', 'lib/tasks/db.rake'

# Add Rubocop tasks to Rakefile
insert_into_file 'Rakefile', before: "require_relative 'config/application'\n" do <<-RUBY
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RUBY
end

# Update to remove rubocop warning
gsub_file 'config/environments/development.rb', "'tmp/caching-dev.txt'", "'tmp', 'caching-dev.txt'"
