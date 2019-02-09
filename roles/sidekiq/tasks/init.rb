app.gem 'sidekiq'

copy_file 'sidekiq/files/sidekiq.rb', 'config/initializers/sidekiq.rb'

insert_into_file "config.ru", after: "run Rails.application\n" do <<-RUBY
# require 'sidekiq/web'
# run Rack::URLMap.new('/' => Rails.application, '/sidekiq' => Sidekiq::Web)
RUBY
end
