gem 'act-fluent-logger-rails'
gem 'lograge'

insert_into_file 'config/application.rb', after: "class Application < Rails::Application\n" do <<-RUBY
    config.log_level = :info
    config.logger = ActFluentLoggerRails::Logger.new
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
RUBY
end

create_file 'config/fluent-logger.yml' do <<-RUBY
development:
  fluent_host:   '127.0.0.1'
  fluent_port:   24224
  tag:           'foo'
  messages_type: 'string'

test:
  fluent_host:   '127.0.0.1'
  fluent_port:   24224
  tag:           'foo'
  messages_type: 'string'

production:
  fluent_host:   '127.0.0.1'
  fluent_port:   24224
  tag:           'foo'
  messages_type: 'string'
RUBY
end
