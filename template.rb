gem 'therubyracer'

# specificy database with -d option
# rails new myapp -d=postgresql

gem_group :development, :test do
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'database_cleaner'
end

@include_sprig = yes?('Include sprig?')
#@include_bootstrap = yes?('Include bootstrap?')
@include_foundation = yes?('Include foundation?')

#gem 'twitter-bootstrap-rails' if @include_bootstrap
gem 'foundation-rails', '5.5.2.1' if @include_foundation

gem_group :development do
  gem 'curb', require: false
  gem 'pry-rails'
  gem 'sprig' if @include_sprig
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'rack-livereload'
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-ctags-bundler', require: false
  gem 'guard-rubocop', require: false
  gem 'brakeman', '~> 3.0', require: false
  gem 'guard-brakeman', require: false
  gem 'rubocop', require: false
end

@github_username = ask('github user name')
@github_reponame = ask('github repo name')

# See: https://github.com/rwz/ember-cli-rails
# See also: https://libraries.io/npm/ember-cli-rails-addon
@ember_cli_rails = yes?('Use ember-cli-rails?')
gem 'ember-cli-rails' if @ember_cli_rails

def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'files')]
end

@include_test_models = yes?('Include test models?')
@include_docker = yes?('Include docker?')
copy_file 'Dockerfile' if @include_docker

# Remove turbolinks
gsub_file 'Gemfile', /gem 'turbolinks'/, ''
gsub_file 'app/assets/javascripts/application.js', /\/\/= require turbolinks/, ''

# Run livereload in development
inject_into_file 'config/environments/development.rb', "  config.middleware.use Rack::LiveReload\n", after: "Rails.application.configure do\n"

inject_into_file 'db/seeds.rb', "include Sprig::Helpers\n", after: ".first)\n" if @include_sprig
#@app_name
#@app_path

copy_file 'Guardfile'
copy_file 'Procfile'
copy_file 'circle.yml'
copy_file 'rubocop.yml', '.rubocop.yml'
template 'env', '.env'
remove_file 'config/database.yml'
copy_file 'database.yml', 'config/database.yml'
copy_file 'db.rake', 'lib/tasks/db.rake'


=begin
# into config/application.rb
  g.template_engine :erb
  g.test_framework  :shoulda, fixture: false
  g.stylesheets     false
  g.javascripts     false
=end


after_bundle do
  git :init
  inject_into_file '.gitignore', "\nproject.tags", after: "/tmp"
  inject_into_file '.gitignore', "\n.env", after: "/tmp"
  run "git remote add origin git@github.com:#{@github_username}/#{@github_reponame}.git"
  run 'bundle exec rails generate rspec:install'
  inject_into_file 'spec/rails_helper.rb', after: "config.infer_spec_type_from_file_location!\n" do <<-'RUBY'

  config.before(:suite) do
    begin
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
      # See: http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md
      # DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
RUBY
  end

  run 'rm -rf test'
  #run 'rails generate bootstrap:install static' if @bootstrap
  run 'rails generate foundation:install' if @foundation
  run 'rails generate ember-cli:init' if @ember_cli_rails
  run 'npm install --save-dev ember-cli-rails-addon@0.0.11' if @ember_cli_rails

  run 'rails generate sprig:install' if @include_sprig

  # Remove after testing
  generate :scaffold, 'blog', 'title:string', 'content:string' if @include_test_models
  rake 'db:migrate db:test:prepare' if @include_test_models

  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
end
