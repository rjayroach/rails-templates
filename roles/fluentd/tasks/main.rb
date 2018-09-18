
if app.docker?
  insert_into_file 'docker-compose-dev.yml', after: "services:\n" do <<-RUBY
  fluentd:
    image: fluent/fluentd
    ports:
      - '24224:24224'
      - '24224:24224/udp'
    volumes:
      - /tmp/${COMPOSE_PROJECT_NAME}/fluentd/log:/fluentd/log

  RUBY
  end
end
