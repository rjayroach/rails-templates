
type = :app
type = :plugin if @app_name.nil?

base_dir = type.eql?(:plugin) ? 'spec/dummy/' : ''
@app_name ||= @app_path

STDOUT.puts '-' * 10
STDOUT.puts type
STDOUT.puts base_dir
STDOUT.puts @app_name
STDOUT.puts @app_path
STDOUT.puts '-' * 10

# rails plugin new ezlink --mountable --skip-test-unit --dummy-path=spec/dummy -m ../rails-templates/template.rb
# See: https://quickleft.com/blog/rails-application-templates/
# apply File.expandpath("../templates/sphinx.rb", _FILE__)
# get URL
# Stop spring if it is running in new app directory
# TODO: This never gets called
STDOUT.puts @app_path
if Dir.exists? @app_path
  STDOUT.puts 'hello'
  @overwrite = yes?('WARNING: DIRECTORY ALREADY EXISTS; Overwrite?')
  begin
    Dir.chdir(@app_path) {spring stop}
  ensure
    Dir.rmdir(@app_path)
  end
end

gem 'therubyracer'
# NOTE: Bug in mysql2 0.4.1 and rails 4.2.4
# See: https://github.com/rails/rails/issues/21544
gem 'mysql2', '~> 0.3.18'

# specificy database with -d option
# rails new myapp -d=postgresql

gem_group :development, :test do
  gem 'factory_girl_rails'
  gem 'dotenv-rails'
  gem 'database_cleaner'
end

@github_username = ask('github user name')
@github_reponame = ask('github repo name')

@include_sprig = false
@include_bootstrap = false
@include_foundation = false
@include_doorkeeper = false
@include_devise = false
@ember_cli_rails = false
@include_test_models = false
@include_docker = false


@include_sprig = yes?('Include sprig?')

if type.eql?(:app)
  #@include_bootstrap = yes?('Include bootstrap?')
  @include_foundation = yes?('Include foundation?')
  @include_doorkeeper = yes?('Include doorkeeper?')
  @include_devise = yes?('Include devise?')
  @ember_cli_rails = yes?('Use ember-cli-rails?')
  @include_test_models = yes?('Include test models?')
  @include_docker = yes?('Include docker?')
end


gem 'twitter-bootstrap-rails' if @include_bootstrap
gem 'foundation-rails', '5.5.2.1' if @include_foundation
gem 'doorkeeper' if @include_doorkeeper
gem 'devise' if @include_devise

gem_group :development do
  # gem 'curb', require: false
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
  gem 'spring-commands-rspec'
  # gem 'rails_best_practices', require: false
  # gem 'raddocs'
end

# group :test do
#   gem 'rspec_api_documentation', require: false
# end

# See: https://github.com/rwz/ember-cli-rails
# See also: https://libraries.io/npm/ember-cli-rails-addon
gem 'ember-cli-rails' if @ember_cli_rails

def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'files')]
end

copy_file 'Dockerfile' if @include_docker

# Remove turbolinks
gsub_file 'Gemfile', /gem 'turbolinks'/, ''
gsub_file("#{base_dir}app/assets/javascripts/application.js", /\/\/= require turbolinks/, '')

# Run livereload in development
# FIXME: Not working with engine
unless type.eql?(:plugin)
  environment 'config.middleware.use Rack::LiveReload', env: 'development'
  append_file 'db/seeds.rb', "include Sprig::Helpers\n"
end


copy_file 'Guardfile'
copy_file 'Procfile'
template 'circle.yml', 'circle.yml'
copy_file 'rubocop.yml', '.rubocop.yml'
template 'env', "#{base_dir}.env"
remove_file "#{base_dir}config/database.yml"
copy_file 'database.yml', "#{base_dir}config/database.yml"
copy_file 'db.rake', "#{base_dir}lib/tasks/db.rake"

if type.eql?(:plugin)
  copy_file 'spring.rb', 'config/spring.rb'

=begin
# into config/application.rb
  g.template_engine :erb
  g.test_framework  :shoulda, fixture: false
  g.stylesheets     false
  g.javascripts     false
=end

  inject_into_file "lib/#{@app_name}/engine.rb", after: "isolate_namespace #{@app_name.capitalize}\n" do <<-'RUBY'
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
RUBY
  end
end


# NOTE: after_bundle should be called by the application framework but it doesn't work for engines
#   Therefore I am overriding run_bundle to call 'bundle install' along with the 'after_bundle' tasks
def run_bundle
  run 'bundle'
#after_bundle do
inside '.' do
  git :init
  append_file '.gitignore', "project.tags\n"
  append_file '.gitignore', ".env\n"
  git remote: "add origin git@github.com:#{@github_username}/#{@github_reponame}.git"
  generate('rspec:install')
  if @include_doorkeeper
    generate('doorkeeper:install')
    generate('doorkeeper:migration')
  end
  generate('devise:install') if @include_devise
  run 'bundle exec spring binstub --all'
  # inject_into_file 'spec/rails_helper.rb', after: "config.fixture_path = \"#{::Rails.root}/spec/fixtures\"\n" do <<-'RUBY'
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
  #generate('bootstrap:install static') if @bootstrap
  generate 'foundation:install' if @foundation
  generate 'ember-cli:init' if @ember_cli_rails
  run 'npm install --save-dev ember-cli-rails-addon@0.0.11' if @ember_cli_rails

  run 'spring rails generate sprig:install' if @include_sprig

  # Remove after testing
  if @include_test_models
    generate :scaffold, 'blog', 'title:string', 'content:string'
    rake 'db:migrate db:test:prepare'
  end

  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
end
end
