# frozen_string_literal: true
# Make a Ros Service Gem
# Make a Ros Service that wraps a Ros Service Gem
# Make a Project Service
# Make a Project Core Gem

if app.ros.tenant
  generate :model, 'Tenant', 'schema_name', 'properties:jsonb', 'platform_properties:jsonb'
  remove_file('app/models/tenant.rb')

  module_string = app.plugin? ? "#{app.application_name.gsub('ros-', '').classify}" : 'Ros'

  create_file 'app/models/tenant.rb' do <<-RUBY
# frozen_string_literal: true

class Tenant < #{module_string}::ApplicationRecord
  include Ros::TenantConcern
end
RUBY
  end
end

if app.ros.require_gems
  gem 'ros-core', path: "#{app.ros.gems_path}/ros/services/core"
  gem 'ros_sdk', path: "#{app.ros.gems_path}/ros/services/sdk"
  # NOTE: The empty group is to put a separator between the above gems and the ones below.
  # Without this, rails template will put them in alphabetical order which is a problem
  gem_group(:development) do
  end
  project = Dir.pwd.split('/').pop(3).first
  gem "#{project}-core", path: '../core'
  gem "#{project}_sdk", path: '../sdk'
end

create_file 'doc/open_api.yml' do <<-FILE
---
api_docs:
  info:
    description: 'Service description'
    version: '0.1.0'
  server:
    description: 'server description'
FILE
end

# insert_into_file "lib/#{@namespaced_name}.rb", before: 'require' do <<-RUBY
# require 'ros/core'
# RUBY
# end

file_name = app.plugin? ? "lib/#{app.application_name.gsub('-', '/')}/engine.rb" : 'config/application.rb'

if app.ros.migrations
  inject_into_file file_name, after: ".api_only = true\n" do <<-RUBY

      # Adds this gem's db/migrations path to the enclosing application's migraations_path array
      # if the gem has been included in an application, i.e. it is not running in the dummy app
      # https://github.com/rails/rails/issues/22261
      initializer :append_migrations do |app|
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
          ActiveRecord::Migrator.migrations_paths << expanded_path
        end unless app.config.paths['db/migrate'].first.include? 'spec/dummy'
      end
RUBY
  end
end

inject_into_file file_name, after: ".api_only = true\n" do <<-RUBY
      initializer :console_methods do |app|
        Ros.config.factory_paths += Dir[Pathname.new(__FILE__).join('../../../../spec/factories')]
        Ros.config.model_paths += config.paths['app/models'].expanded
      end if Rails.env.development?
RUBY
end

if app.ros.service
  inject_into_file file_name, after: ".api_only = true\n" do <<-RUBY
    config.after_initialize do
      Settings.service['name'] = '#{app.application_name.gsub('ros-', '')}'
      Settings.service['policy_name'] = '#{app.application_name.gsub('ros-', '').classify}'
    end
RUBY
  end
end

inject_into_file "#{app.app_dir}/config/routes.rb", after: "routes.draw do\n" do <<-RUBY
  extend Ros::Routes
  mount Ros::Core::Engine => '/'
RUBY
  end

inject_into_file "#{app.app_dir}/config/routes.rb", before: /^end/ do <<-RUBY
  catch_not_found
RUBY
end
