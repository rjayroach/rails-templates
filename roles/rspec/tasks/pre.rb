if app.selected.include?(:rspec)
  remove_dir 'test'
  gem_group :development do
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'spring-commands-rspec'
  end
  gem_group :development, :test do
    gem 'database_cleaner'
  end
end
