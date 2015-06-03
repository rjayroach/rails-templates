namespace :db do
  namespace :migrate do
    desc 'Run all migrations against a clean (new) database'
    task clean: [:environment] do
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:seed'].invoke
    end
  end

  desc 'Truncate all existing data'
  task truncate: [:environment] do
    DatabaseCleaner.clean_with :truncation
  end
end
