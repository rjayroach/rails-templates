
app.gem 'devise'
app.gem 'pundit'
# app.gem 'rolify'
app.gem 'jwt'
# app.gem 'knock'
# app.gem 'doorkeeper'

# Create some pundit seeds
app.append_to_file 'db/seeds/iam_roles.seeds.rb', 'roles.seeds.rb'
app.append_to_file 'db/seeds/development/users.seeds.rb', 'users.seeds.rb'
app.append_to_file 'README.md'
