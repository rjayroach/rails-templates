
# 1a. is this ros
# 1b. is this a plugin or a service
# 1c. this is not ros; is this a plugin or a service

app.gem_group :development, :test do
  app.gem 'brakeman', require: false
  app.gem 'pry-byebug'
  app.gem 'pry-stack_explorer'
  app.gem 'faker'
end

# app.append_to_file 'README.md'

# Project Root files
# remove_file('README.md')

if app.ros.seeds
# remove_file('db/seeds.rb')
create_file 'spec/dummy/db/seeds.rb' if app.plugin?
create_file 'db/seeds/development/tenants.seeds.rb' do <<-RUBY
# frozen_string_literal: true

start_id = (Tenant.last&.id || 0) + 1
(start_id..start_id + 1).each do |id|
  is_even = (id % 2).zero?
  Tenant.create!(schema_name: Tenant.account_id_to_schema(id.to_s * 9))
end
RUBY
end

create_file db/seeds/development/data.seeds.rb do <<-RUBY
# frozen_string_literal: true

after 'development:tenants' do
  Tenant.all.each do |tenant|
    is_even = (tenant.id % 2).zero?
    next if tenant.id.eql? 1
    tenant.switch do
    end
  end
end
RUBY
end
end

# Create a rake task that imports seedback seeds
if app.plugin?
  namespace = app.application_name.gsub('ros-', '')
  rake_file = "lib/tasks/ros/#{namespace}_tasks.rake"
  remove_file(rake_file)
  create_file rake_file do <<-RUBY

# frozen_string_literal: true

namespace :ros do
  namespace :#{namespace} do
    namespace :db do
      desc 'Load engine seeds'
      task :seed do
        seedbank_root = Seedbank.seeds_root
        Seedbank.seeds_root = File.expand_path('db/seeds', Ros::#{namespace.classify}::Engine.root)
        Seedbank.load_tasks
        Rake::Task["db:seed"].invoke
        Seedbank.seeds_root = seedbank_root 
      end
    end
  end
end
RUBY
  end
end

# Create engine's namespaced classes
if app.ros.application_classes and app.plugin?
  remove_dir('app/mailers')
  namespace = app.application_name.gsub('ros-', '')
  module_name = namespace.classify

  # Create ApplicationRecord
  create_file "app/models/#{namespace}/application_record.rb" do <<-RUBY
# frozen_string_literal: true

module #{module_name}
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true
  end
end
RUBY
  end

  # Create ApplicationResource
  create_file "app/resources/#{namespace}/application_resource.rb" do <<-RUBY
# frozen_string_literal: true

module #{module_name}
  class ApplicationResource < ::ApplicationResource
    abstract
  end
end
RUBY
  end

  # Create ApplicationPolicy
  create_file "app/policies/#{namespace}/application_policy.rb" do <<-RUBY
# frozen_string_literal: true

module #{module_name}
  class ApplicationPolicy < ::ApplicationPolicy
  end
end
RUBY
  end

  # Create ApplicationController
  create_file "app/controllers/#{namespace}/application_controller.rb" do <<-RUBY
# frozen_string_literal: true

module #{module_name}
  class ApplicationController < ::ApplicationController
  end
end
RUBY
  end

  # Create ApplicationJob
  create_file "app/jobs/#{namespace}/application_job.rb" do <<-RUBY
# frozen_string_literal: true

module #{module_name}
  class ApplicationJob < ::ApplicationJob
  end
end
RUBY
  end
end

# Modify spec/dummy or app Base Classes
if app.ros.application_classes
  namespace = app.plugin? ? 'spec/dummy/' : ''
  remove_dir("#{namespace}app/javascript")
  remove_dir("#{namespace}app/assets")

  # Modify ApplicationRecord
  inject_into_file "#{namespace}app/models/application_record.rb", after: "ActiveRecord::Base\n" do <<-RUBY
    include Ros::ApplicationRecordConcern
RUBY
  end

  # Create ApplicationResource
  create_file "#{namespace}app/resources/application_resource.rb" do <<-RUBY
# frozen_string_literal: true

class ApplicationResource < Ros::ApplicationResource
  abstract
end
RUBY
  end

  # Create ApplicationPolicy
  create_file "#{namespace}app/policies/application_policy.rb" do <<-RUBY
# frozen_string_literal: true

class ApplicationPolicy < Ros::ApplicationPolicy
end
RUBY
  end

  # Modify ApplicationController
  inject_into_file "#{namespace}app/controllers/application_controller.rb", after: "ActionController::API\n" do <<-RUBY
    include Ros::ApplicationControllerConcern
RUBY
  end

  # Modify ApplicationJob
  gsub_file "#{namespace}app/jobs/application_job.rb", 'ActiveJob::Base', 'Ros::ApplicationJob'
end

# copy_file 'defaults/files/Procfile', 'Procfile'
# template 'defaults/files/tmuxinator.yml', '.tmuxinator.yml'

# Rake task files
# TODO: maybe this should be in dummy_path / @app_dir if it is a plugin
# copy_file 'defaults/files/db.rake', 'lib/tasks/db.rake'


# Create some pundit seeds
# app.append_to_file 'db/seeds/iam_roles.seeds.rb', 'roles.seeds.rb'
# app.append_to_file 'db/seeds/development/users.seeds.rb', 'users.seeds.rb'
# app.append_to_file 'README.md'
