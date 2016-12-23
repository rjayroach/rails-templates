inside 'config' do
  remove_file 'database.yml'
  create_file 'database.yml' do <<-EOF
default: &default
  adapter: postgresql
  database: <%= ENV['DATABASE_NAME'] %>
  encoding: unicode
  host: <%= ENV['DATABASE_HOST'] || 'localhost' %>
  password: <%= ENV['DATABASE_PASSWORD'] || '#{ENV["USER"]}' %>
  port: 5432
  timeout: 5000
  username: <%= ENV['DATABASE_USERNAME'] || '#{ENV["USER"]}' %>

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
