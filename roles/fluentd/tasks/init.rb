gem 'act-fluent-logger-rails'
gem 'lograge'

# insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-RUBY
#     config.log_level = :debug
#     config.logger = ActFluentLoggerRails::Logger.new
#     config.lograge.enabled = true
#     config.lograge.formatter = Lograge::Formatters::Json.new
# RUBY
# end

# TODO: This should probably be in a specific environment rather than application wide
# This effectively does an insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-RUBY
application do <<-RUBY
# config.log_level = :debug
config.logger = ActFluentLoggerRails::Logger.new
config.lograge.enabled = true
config.lograge.formatter = Lograge::Formatters::Json.new
RUBY
end

# template 'fluentd/files/fluent-logger.yml', 'config/fluent-logger.yml'
copy_file 'fluentd/files/fluent-logger.yml', 'config/fluent-logger.yml'

append_file '.env', "FLUENTD_HOST=127.0.0.1\n"
append_file '.env', "FLUENTD_TAG=#{app.application_name}\n"
