
gem_group :development, :test do
  gem 'rubocop', require: false
end

copy_file 'rubocop/files/rubocop.yml', '.rubocop.yml'

# Add Rubocop tasks to Rakefile
# insert_into_file 'Rakefile', before: "require_relative 'config/application'\n" do <<-RUBY
append_to_file 'Rakefile' do <<-RUBY
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RUBY
end
