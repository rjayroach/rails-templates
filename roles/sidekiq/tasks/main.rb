
if app.docker?
  insert_into_file 'docker-compose.yml', after: "services:\n" do <<-RUBY
  sidekiq:
    image: "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
    links:
      - redis
    env_file:
      - ./.env
    environment:
      RAILS_MAX_THREADS: 10
    command: bundle exec sidekiq -q #{app.application_name}_production_default

  RUBY
  end

  insert_into_file 'docker-compose-dev.yml', after: "services:\n" do <<-RUBY
  sidekiq:
    links:
      - postgres

  RUBY
  end
end
