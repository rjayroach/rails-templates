
# class Tenant < Doorkeeper::Application
class Tenant < ApplicationRecord
  SERVICE_CALLS = %w(device user merchant service reward scratch_card stored_value survey).freeze

  # belongs_to :account
  # has_many :users, through: :account

  before_validation :set_defaults, on: :create
  before_validation :set_schema_name, on: :create

  # validates :account, presence: true
  validates :schema_name, presence: true, uniqueness: true
  # validates :subdomain, presence: true, uniqueness: true

  after_create :create_tenant_services, unless: -> { Rails.env.test? }
  after_destroy :destroy_tenant_services, unless: -> { Rails.env.test? }

  # resourcify

  def set_defaults
    self.redirect_uri ||= 'urn:ietf:wg:oauth:2.0:oob'
    self.time_zone ||= 'UTC'
    self.available_locales ||= 'en'
    self.rate_limit_value ||= 1000
    self.rate_limit_period ||= 'Daily'
    # self.subdomain ||= calculated_subdomain
  end

  def calculated_subdomain
    return unless name
    name.tr(' ', '_')
  end

  def calculated_schema_name
    "#{account.name[0..10]} #{name}".tr(' ', '_').tr('^A-Za-z0-9_', '').downcase[0..33]
  end

  def set_schema_name
    return unless name
    schema_name_base = schema_name_try = calculated_schema_name
    iteration = 0
    self.schema_name = loop do
      break schema_name_try unless self.class.find_by(schema_name: schema_name_try)
      errors.add(:unique_name, 'Cannot create') and break if iteration == 10
      schema_name_try = "#{schema_name_base[0..31]}_#{iteration += 1}"
    end
  end

  def seed!
    Seed.run(schema_name)
  end

  def seed_legacy!
    Seed.run_legacy(schema_name)
  end

  def create_tenant_services
    Apartment::Tenant.create(schema_name)
    # return if ENV['SKIP_TENANT_CREATE']
    # CreateServiceTenantsJob.perform_later(self)
  end

  def destroy_tenant_services
    SERVICE_CALLS.each do |service|
      service_tenant = "ApiV1::#{service.classify}::Tenant".constantize.where(schema_name: self.schema_name).first
      Rails.logger.info { "Tenant not found" } and next if service_tenant.nil?
      service_tenant.destroy
      Rails.logger.info { "Dropped #{service.capitalize} service #{self.schema_name}" }
    end
  end
end
