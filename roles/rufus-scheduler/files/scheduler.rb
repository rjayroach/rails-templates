require 'rufus-scheduler'

Rails.application.config.after_initialize do
  Rails.logger.info "#{Time.now} Scheduler - Looking for ENVs to schedule"

  if config = YAML.load_file('config/scheduler.yml')
    config['tasks'].each do |action, method|
      config['schedule'].each do |schedule|
        next unless setting = ENV["schedule_#{action}_#{schedule}".upcase]
        Rufus::Scheduler.singleton.send(schedule, setting) do
          Rails.logger.info "#{Time.now} Scheduler - Running #{action.pluralize} (#{method})"
          Rails.logger.flush
          ActiveRecord::Base.connection_pool.with_connection { eval(method) }
          Rails.logger.info "#{Time.now} Scheduler - Completed #{action.pluralize} (#{method})"
          Rails.logger.flush
        rescue => e
          Rails.logger.warn(e.message)
          Rails.logger.warn(e.backtrace.join("\n"))
          Rails.logger.flush
        end
        Rails.logger.info "#{Time.now} Scheduler - Scheduled #{action.pluralize} #{schedule} '#{setting}'"
      end
    end
  end

  Rails.logger.flush
end
