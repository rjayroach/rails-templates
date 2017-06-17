# TODO:
# Implement https://github.com/brigade/overcommit

# See: https://www.sitepoint.com/rails-application-templates-real-world/
def source_paths
  c_dir = File.expand_path(File.dirname(__FILE__))
  Array(super) + [c_dir, File.join(c_dir, '../all'), File.join(c_dir, '../files')]
end

apply('common.rb')

asker(:docker, 'Docker?')
asker(:pg, 'Add postgres?')
asker(:cors, 'Add CORS?')
asker(:guard, 'Add Guard?')
asker(:jsonapi, 'JSON API Resources?')
asker(:grpc, 'GRPC?')
asker(:rspec, 'RSpec?')
asker(:trailblazer, 'Trailblazer?')
asker(:exception_notification, 'Exception Notifications?')
asker(:slack_notifier, 'Slack Notifications?')
asker(:circleci, 'Circle CI?')
asker(:devise, 'Devise?')

apply('common_config.rb')

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

if not plugin?
  apply('application.rb')
elsif full? || mountable?
  apply('plugin.rb')
end

after_bundle do
  # wrap with #inside b/c otherwise when a plugin is created pwd is dummy_path
  inside('.') do
    apply('rspec.rb') if @packages.include?(:rspec)
    run 'bundle exec rake rubocop:auto_correct'
    apply('git.rb')
    run 'spring stop'
  end
end
