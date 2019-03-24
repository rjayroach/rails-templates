
generate :model, 'tenant', 'name', 'schema_name', 'redirect_uri', 'time_zone', 'available_locales', 'rate_limit_value:integer', 'rate_limit_period', 'subdomain'
rails_command 'db:migrate'


copy_file 'apartment/files/apartment.rb', 'config/initializers/apartment.rb'
remove_file 'app/models/tenant.rb'
copy_file 'apartment/files/tenant.rb', 'app/models/tenant.rb'

# Add model which has after create to put a job on the queue to create tenants in other services
# Add job which does the work
