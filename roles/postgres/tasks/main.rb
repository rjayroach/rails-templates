
if app.docker?
  insert_into_file 'docker-compose-dev.yml', after: "services:\n" do <<-RUBY
  postgres:
    image: postgres
    environment:
      POSTGRES_USER: rails
      POSTGRES_PASSWORD: rails_pwd
      POSTGRES_DB: #{app.application_name}_development
    ports:
      - '5432:5432'
    volumes:
      - '/tmp/${COMPOSE_PROJECT_NAME}/docker/postgres/data:/var/lib/postgresql/data'

  app:
    links:
      - postgres
    environment:
      X_DATABASE_URL: postgres://rails:rails_pwd@postgres/#{app.application_name}_development

  RUBY
  end
end
