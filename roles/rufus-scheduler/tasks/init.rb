gem 'rufus-scheduler'

copy_file 'rufus-scheduler/files/scheduler.rb', 'config/initializers/scheduler.rb'
copy_file 'rufus-scheduler/files/scheduler.yml', 'config/scheduler.yml'
