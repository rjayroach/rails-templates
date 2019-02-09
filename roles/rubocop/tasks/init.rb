# rubocop/tasks/init.rb

app.gem_group :development, :test do
  app.gem 'rubocop', require: false
end

copy_file 'rubocop/files/rubocop.yml', '.rubocop.yml'

# Update to remove rubocop warning
gsub_file "#{app.app_dir}/config/environments/development.rb", "'tmp/caching-dev.txt'", "'tmp', 'caching-dev.txt'"

# Add Rubocop tasks to Rakefile
# insert_into_file 'Rakefile', before: "require_relative 'config/application'\n" do <<-RUBY
append_to_file 'Rakefile' do <<-RUBY

if Rails.env.development?
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

RUBY
end
