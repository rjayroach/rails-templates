
inject_into_file 'spec/rails_helper.rb', after: "Rails is not loaded until this point!\n" do <<-'RUBY'
require 'pry'
Dir[Rails.root.join('../..', 'spec/support/**/*.rb')].each { |f| require f }
Dir[Rails.root.join('../..', 'spec/factories/**/*.rb')].each { |f| require f }
RUBY
end

inject_into_file 'spec/rails_helper.rb', after: "config.infer_spec_type_from_file_location!\n" do <<-'RUBY'
  config.include FactoryGirl::Syntax::Methods
RUBY
end

# TODO: remove tconfig.fixture_path:
# -  config.fixture_path = "#{::Rails.root}/spec/fixtures"
# TODO: comment out use_transactional_fixtures:
# # config.use_transactional_fixtures = true

inject_into_file 'spec/rails_helper.rb', after: "config.infer_spec_type_from_file_location!\n" do <<-'RUBY'

  config.before(:suite) do
    begin
      # See: http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
RUBY
end
