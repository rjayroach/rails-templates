# See: http://monksealsoftware.com/add-rubocop-to-every-rails-project/
begin
  require 'rubocop/rake_task'
  namespace :ci do
    def changed_files
      cmd = %q( git diff --name-only --diff-filter=ACMRTUXB \
      $(git merge-base HEAD master) \
      | egrep '\.rake$|\.rb$' )
      diff = `#{cmd}`
      diff.split("\n")
    end

    def patterns_for_changed_files
      # always include the ci.rake file, if the patterns is empty it runs everything
      patterns = ['<%= @base_dir %>lib/tasks/ci.rake']
      patterns + changed_files - ['<%= @base_dir %>db/schema.rb']
    end

    desc 'Run RuboCop on the entire project'
    RuboCop::RakeTask.new('rubocop') do |task|
      task.fail_on_error = true
    end

    desc 'Run RuboCop on the project based on git diff'
    RuboCop::RakeTask.new('rubocop_changed') do |task|
      task.patterns = patterns_for_changed_files
      task.fail_on_error = true
    end
  end
rescue LoadError
  STDOUT.puts 'cannot load rubocop/rake_task'
end
