
# Apartment seeds
Tenant.create(schema_name: 'abc')
Tenant.create(schema_name: 'xyz')
Apartment::Tenant.switch!('abc')
