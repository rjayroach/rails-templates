namespace :db do
  desc 'Truncate all existing data in all schemas'
  task clean: [:environment] do
    DatabaseCleaner.strategy = :truncation #, {cache_tables: false}
    # tld = ENV['APPLICATION_NAME'].classify.constantize
    # (tld::Tenant.all.map(&:schema_name) << 'public').each do |schema_name|
    #  Apartment::Tenant.switch!(schema_name)
      DatabaseCleaner.clean
    # end
    Rake::Task['db:environment:set'].invoke #() RAILS_ENV=development
  end

  namespace :clean do
    desc 'Run all migrations against a clean (new) database'
    task migrate: ['db:drop', 'db:create'] do
      Rake::Task['db:migrate'].invoke
    end

    desc 'Run all migrations against a clean (new) database AND seed it'
    task seed: [:clean] do
      Rake::Task['db:seed'].invoke
    end

    namespace :migrate do
      desc 'Truncate all existing data and run seeds'
      task seed: ['db:clean:migrate'] do
        Rake::Task['db:seed'].invoke
      end
    end
  end
end
