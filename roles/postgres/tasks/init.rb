# frozen_string_literal: true

gem 'pg'

# run 'sudo apt install libpq-dev'
database_prefix = "#{app.application_name.remove('ros-').tr('-', '_')}"

inside "#{app.app_dir}/config" do
  remove_file 'database.yml'
  create_file 'database.yml' do <<-EOF

default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch('RAILS_DATABASE_HOST') { 'localhost' } %>
  username: <%= ENV.fetch('RAILS_DATABASE_USER') { '#{Etc.getlogin}' } %>
  password: <%= ENV.fetch('RAILS_DATABASE_PASSWORD') { '#{Etc.getlogin}' } %>
  pool: <%= ENV.fetch('RAILS_MAX_THREADS') { 5 } %>
  port: 5432
  timeout: 5000

development:
  <<: *default
  database: #{database_prefix}_development

test:
  <<: *default
  database: #{database_prefix}_test

production:
  <<: *default
  database: #{database_prefix}_production
EOF
  end
end
