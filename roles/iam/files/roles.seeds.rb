# Create a Service with a permitted Action
Action.count
service = Service.create(name: 'User')
action = ReadAction.create(service: service, name: 'DescribeUser')

# Create a few Policies
policy_admin = Policy.create(name: 'AdministratorAccess')
policy_user_full = Policy.create(name: 'PerxUserFullAccess')
policy_user_read_only = Policy.create(name: 'PerxUserReadOnlyAccess')

# Attach the Action to the Admin Policy
policy_admin.actions << action

# Create a Group
group_admin = Group.create(name: 'Administrators')

# Attach the Admin Policy to the Group
group_admin.policies << policy_admin

# Create a User
user_admin = User.create(email: 'admin@example.com', password: 'abc123za')

# Assign the User to the Admin Group
group_admin.users << user_admin




# Role.create(name: 'PerxServiceRoleForIAM')
# Role.create(name: 'PerxUserReadOnlyAccess')
