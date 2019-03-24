
# Service
generate :model, 'Service', 'name'
generate :model, 'Action', 'service:references', 'name', 'type'

# Policy
generate :model, 'Policy', 'name'
generate :model, 'PolicyAction', 'policy:references', 'action:references'

# User - Create the devise install
generate 'devise:install'
generate :devise, 'User'
rails_command 'db:migrate'

# Create the rolify install
# generate 'rolify Role User'
# rails_command 'db:migrate'

# Group and Role
generate :model, 'Group', 'name'
generate :model, 'Role', 'name'

# Join User to Group and Role
generate :model, 'UserGroup', 'user:references', 'group:references'
generate :model, 'UserRole', 'user:references', 'role:references'

# Join User, Group and Role to Policy
generate :model, 'ActiveGroupPolicy', 'group:references', 'policy:references'
generate :model, 'ActiveUserPolicy', 'user:references', 'policy:references'
generate :model, 'ActiveRolePolicy', 'role:references', 'policy:references'

app.copy_to_dir('app/models', 'models', :now)

rails_command 'db:migrate'

# Pundit
generate 'pundit:install'
app.copy_to_dir('app/policies', 'policies', :now)

# rails_command 'db:seed'
