
if app.docker?
  insert_into_file 'docker-compose.yml', after: "services:\n" do <<-RUBY
  grpc:
    image: "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
    ports:
      - '50051:50051'
    env_file:
      - ./.env
    command: bundle exec rake grpc

  RUBY
  end
end
