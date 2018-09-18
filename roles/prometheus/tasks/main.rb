
if app.docker?
  insert_into_file 'docker-compose-dev.yml', after: "services:\n" do <<-RUBY
  prometheus:
    image: prom/prometheus
    ports:
      - '9090:9090'
    volumes:
      - '/tmp/${COMPOSE_PROJECT_NAME}/prometheus/data:/prometheus'
      - './prometheus.yml:/etc/prometheus/prometheus.yml'

  RUBY
  end
end
