gem 'prometheus-client'

insert_into_file 'config.ru', after: "require_relative 'config/environment'\n" do <<-RUBY
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'

  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
RUBY
end


create_file 'config/prometheus.rb' do <<-RUBY
# See: https://www.robustperception.io/instrumenting-a-ruby-on-rails-application-with-prometheus/

module Prometheus
  module Controller
    # Create a default Prometheus registry for our metrics.
    prometheus = Prometheus::Client.registry

    # Create a simple gauge metric.
    GAUGE_EXAMPLE = Prometheus::Client::Gauge.new(:gauge_example, 'A simple gauge that rands between 1 and 100 inclusively.')

    # Register GAUGE_EXAMPLE with the registry we previously created.
    prometheus.register(GAUGE_EXAMPLE)
  end
end
  RUBY
end
