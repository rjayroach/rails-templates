
# Build the Gemfile from scratch
remove_file 'Gemfile'
run 'touch Gemfile'

add_source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
gem 'dotenv-rails'

# Server
gem 'puma', '~> 3.0'
gem 'rack-cors'

# Data and Models
gem 'jsonapi-resources'
gem 'pg', '~> 0.18'

# Console
gem 'pry-rails'
gem 'awesome_print'

# Utilities
gem 'slack-notifier'


gem_group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'

  gem 'guard-rspec', require: false
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-ctags-bundler', require: false
  gem 'guard-rubocop', require: false
  gem 'brakeman', '~> 3.0', require: false
  gem 'guard-brakeman', require: false
  gem 'rubocop', require: false
end

gem_group :development, :test do
  gem 'byebug', platform: :mri
  gem 'database_cleaner'
end

gem_group :production do
  gem 'exception_notification'
end
