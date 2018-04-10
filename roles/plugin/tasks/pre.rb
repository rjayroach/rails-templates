
insert_into_file "lib/#{@name}/engine.rb", after: "class Engine < ::Rails::Engine\n" do <<-RUBY
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.template_engine false
      g.routing_specs false
    end
RUBY
end

# NOTE: The run command is executed in dummy_path so no need to chdir to it
run 'ln -s ../../.env'

# See: https://github.com/rails/spring/issues/323#ref-issue-54884721
template 'defaults/spring.rb', 'config/spring.rb'

if @packages.include?(:rspec)
  insert_into_file "lib/#{@name}/engine.rb", after: "class Engine < ::Rails::Engine\n" do <<-RUBY
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
RUBY
  end
end

# NOTE: create an empty config/environment.rb otherwise Rails.vim is not available
create_file 'config/environment.rb'
