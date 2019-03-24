# frozen_string_literal: true

remove_dir 'test'

app.gem_group :development, :test do
  app.gem 'rspec-rails'
  app.gem 'factory_bot_rails'
  app.gem 'spring-commands-rspec'
  app.gem 'database_cleaner'
end

copy_file 'rspec/files/linter.rb', 'spec/linter.rb'

if app.plugin?
inject_into_file "lib/#{name.gsub('-', '/')}/engine.rb", after: "config.generators.api_only = true\n" do <<-RUBY
      config.generators do |g|
        g.test_framework :rspec, fixture: true
        g.fixture_replacement :factory_bot, dir: 'spec/factories'
      end

RUBY
end
end
