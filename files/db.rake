namespace :db do
  namespace :migrate do
    desc 'Run all migrations against a clean (new) database'
    task :clean => [:environment] do
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:seed'].invoke
    end
  end
end
