gem 'prometheus-client'

insert_into_file 'config.ru', after: "require_relative 'config/environment'\n" do <<-RUBY

# Prometheus
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter
RUBY
end

copy_file 'prometheus/files/prometheus.rb', 'config/prometheus.rb'
copy_file 'prometheus/files/prometheus.yml', 'prometheus.yml'
