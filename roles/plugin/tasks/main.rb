
=begin
insert_into_file "lib/#{app.application_name}/engine.rb", after: "class Engine < ::Rails::Engine\n" do <<-RUBY
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.template_engine false
      g.routing_specs false
    end
RUBY
end

# See: https://github.com/rails/spring/issues/323#ref-issue-54884721
template 'defaults/spring.rb', 'config/spring.rb'

if app.rspec?
  insert_into_file "lib/#{app.application_name}/engine.rb", after: "class Engine < ::Rails::Engine\n" do <<-RUBY
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
RUBY
  end
end
=end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# https://medium.com/@mohnishgj/how-to-setup-rspec-factory-bot-and-spring-for-a-rails-5-engines-154af307c12d
create_file 'config/spring.rb' do <<-RUBY
# frozen_string_literal: true

Spring.application_root = './spec/dummy'
RUBY
end

run 'bundle exec spring binstub --all'

# NOTE: create an empty config/environment.rb otherwise Rails.vim is not available
create_file 'config/environment.rb'
