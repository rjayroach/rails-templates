require 'rufus-scheduler'

if defined?(Puma::Server) or defined?(Rails::Server)
  Rails.application.config.after_initialize do
    Rails.logger.debug 'Configuring scheduler'

    if config = YAML.load_file('config/scheduler.yml')
      config['tasks'].each do |action, method|
        config['schedule'].each do |schedule|
          next unless setting = ENV["schedule_#{action}_#{schedule}".upcase]
          Rufus::Scheduler.singleton.send(schedule, setting) do
            ActiveRecord::Base.connection_pool.with_connection { eval(method) }
          end
          Rails.logger.info "#{Time.now} Scheduled #{action.pluralize} #{schedule} '#{setting}'"
        end
      end
    end

    Rails.logger.flush
  end
end
