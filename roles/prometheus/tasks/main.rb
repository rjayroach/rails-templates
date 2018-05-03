
if app.docker?
  insert_into_file 'docker-compose-dev.yml', after: "services:\n" do <<-RUBY
  prometheus:
    image: prom/prometheus
    ports:
      - '9090:9090'
    volumes:
      - ./docker/prometheus/data:/prometheus

  RUBY
  end
end
