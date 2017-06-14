# TODO:
# Implement https://github.com/brigade/overcommit

# See: https://www.sitepoint.com/rails-application-templates-real-world/
def source_paths
  c_dir = File.expand_path(File.dirname(__FILE__))
  Array(super) + [c_dir, File.join(c_dir, '../all'), File.join(c_dir, '../files')]
end

apply('common.rb')

asker(:pg, 'Add postgres?')
asker(:cors, 'Add CORS?')
asker(:guard, 'Add Guard?')
asker(:jsonapi, 'JSON API Resources?')
asker(:grpc, 'GRPC?')
asker(:rspec, 'RSpec?')
asker(:trailblazer, 'Trailblazer?')
asker(:exception_notification, 'Exception Notifications?')
asker(:slack_notifier, 'Slack Notifications?')
asker(:devise, 'Devise?')
asker(:docker, 'Docker?')


# Common template
remove_file 'Gemfile'
copy_file 'Gemfile.base', 'Gemfile'

# Common Gemfiles
gem 'dotenv-rails'
gem 'pry-rails'
gem 'awesome_print'

apply('tools.rb')

# User Requested Templates
apply('pg.rb') if @packages.include?(:pg)
apply('cors.rb') if @packages.include?(:cors)
apply('guard.rb') if @packages.include?(:guard)
apply('jsonapi.rb') if @packages.include?(:jsonapi)
apply('grpc.rb') if @packages.include?(:grpc)
apply('trailblazer.rb') if @packages.include?(:trailblazer)
apply('docker.rb') if @packages.include?(:docker)

gem 'devise' if @packages.include?(:devise)

if @packages.include?(:rspec)
  remove_dir 'test'
  gem_group :development do
    gem 'rspec-rails'
    gem 'factory_girl_rails'
    gem 'spring-commands-rspec'
  end
  gem_group :development, :test do
    gem 'database_cleaner'
  end
end

if @packages.include?(:exception_notification)
  gem_group :production do
    gem 'exception_notification'
  end
end

if @packages.include?(:slack_notifier)
  # gem_group :production do
    gem 'slack-notifier'
    # TODO:
    # Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'], channel: 'recheck'
    # notifier.ping "Hello World"
  # end
end

application do <<-RUBY
config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.template_engine false
      g.routing_specs false
    end
RUBY
end

after_bundle do
  apply('rspec.rb') if @packages.include?(:rspec)
  run 'bundle exec rake rubocop:auto_correct'
  apply('git.rb')
  run 'spring stop'
end
