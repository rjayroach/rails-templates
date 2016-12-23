inside 'config' do
  remove_file 'database.yml'
  create_file 'database.yml' do <<-EOF
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV['DATABASE_HOST'] || 'localhost' %>
  port: 5432
  timeout: 5000
  username: <%= ENV['DATABASE_USERNAME'] || '#{ENV["USER"]}' %>
  password: <%= ENV['DATABASE_PASSWORD'] || '#{ENV["USER"]}' %>

  # For details on connection pooling, see rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV['RAILS_MAX_THREADS'] || 5 %>

development:
  <<: *default
  database: <%= ENV['DATABASE_NAME'] || '#{app_name.tr('-', '_')}' %>_development

test:
  <<: *default
  database: <%= ENV['DATABASE_NAME'] || '#{app_name.tr('-', '_')}' %>_test

production:
  <<: *default
  database: <%= ENV['DATABASE_NAME'] %>_production
  host: <%= ENV['DATABASE_HOST'] %>
  username: <%= ENV['DATABASE_USERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>

EOF
  end
end
