gem 'therubyracer'

# specificy database with -d option
# rails new myapp -d=postgresql

gem_group :development do
  gem 'dotenv'
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'rack-livereload'
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-ctags-bundler', require: false
  gem 'brakeman', require: false
  gem 'cane', require: false
end

@github_username = ask('github user name')
@github_reponame = ask('github repo name')

# See: https://github.com/rwz/ember-cli-rails
# See also: https://libraries.io/npm/ember-cli-rails-addon
@ember_cli_rails = yes?('Use ember-cli-rails?')
gem 'ember-cli-rails' if @ember_cli_rails

# Remove turbolinks
gsub_file 'Gemfile', /gem 'turbolinks'/, ''
gsub_file 'app/assets/javascripts/application.js', /\/\/= require turbolinks/, ''

# Run livereload in development
inject_into_file 'config/environments/development.rb', "  config.middleware.use Rack::LiveReload\n", after: "Rails.application.configure do\n"

def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'files')]
end

copy_file 'Guardfile'
copy_file 'Procfile'
copy_file 'circle.yml'

after_bundle do
  git :init
  inject_into_file '.gitignore', "\ngems.tags", after: "/tmp"
  inject_into_file '.gitignore', "\n.env", after: "/tmp"
  git add: '.'
  git commit: %Q{ -m 'Initial commit' }
  run "git remote add origin git@github.com:#{@github_username}/#{@github_reponame}.git"
  run 'bundle exec rails generate rspec:install'
  run 'rm -rf test'
  run 'rails generate ember-cli:init' if @ember_cli_rails
  run 'npm install --save-dev ember-cli-rails-addon@0.0.11' if @ember_cli_rails

  # Remove after testing
  generate :scaffold, 'blog', 'title:string', 'content:string'
  rake 'db:migrate db:test:prepare'

end


@include_docker = yes?('Include docker?')
copy_file 'Dockerfile' if @include_docker
