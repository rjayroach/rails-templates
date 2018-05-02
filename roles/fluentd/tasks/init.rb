gem 'act-fluent-logger-rails'
gem 'lograge'

insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-RUBY
    config.log_level = :info
    config.logger = ActFluentLoggerRails::Logger.new
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
RUBY
end

copy_file 'fluentd/files/fluent-logger.yml', 'config/fluent-logger.yml'
