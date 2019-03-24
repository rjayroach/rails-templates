Apartment.configure do |config|
  # model_name = "#{Rails.application.engine_name.gsub('_application', '').classify}::Tenant"
  # model_name = "#{ENV['APPLICATION_NAME'].classify}::Tenant"
  # model_name = "#{Rails.application.class.module_parent}::Tenant"
  model_name = 'Tenant'
  config.tenant_names = proc { model_name.constantize.pluck(:schema_name) }
  config.excluded_models = [model_name]
end
