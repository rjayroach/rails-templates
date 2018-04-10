gem 'pg'

append_file '.env', "DATABASE_NAME=#{app.application_name}_development\n"
append_file '.env', "DATABASE_TEST=#{app.application_name}_test\n"
append_file '.env', "DATABASE_HOST=localhost\n"
append_file '.env', "DATABASE_USERNAME=#{ENV['USER']}\n"
append_file '.env', "DATABASE_PASSWORD=#{ENV['USER']}\n"

inside "#{app.app_dir}/config" do
  remove_file 'database.yml'
  create_file 'database.yml' do <<-EOF
default: &default
  adapter: postgresql
  database: <%= ENV['DATABASE_NAME'] %>
  encoding: unicode
  host: <%= ENV['DATABASE_HOST'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  port: 5432
  timeout: 5000
  username: <%= ENV['DATABASE_USERNAME'] %>

  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV['RAILS_MAX_THREADS'] || 5 %>

development:
  <<: *default

test:
  <<: *default
  database: <%= ENV['DATABASE_TEST'] %>

production:
  <<: *default
  host: <%= ENV['DATABASE_HOST'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  username: <%= ENV['DATABASE_USERNAME'] %>
EOF
  end
end
