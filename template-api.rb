
gem 'pry-rails'
gem 'awesome_print'
gem 'pg'
gem 'jsonapi-resources', '~> 0.7.1.beta2'

gem_group :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'database_cleaner'
end

gsub_file 'Gemfile', /gem 'sqlite3'/, ''
