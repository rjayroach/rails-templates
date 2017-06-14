gem_group :development do
  gem 'guard-rspec', require: false
  gem 'guard-livereload', require: false
  gem 'guard-ctags-bundler', require: false
  gem 'guard-rubocop', require: false
  gem 'guard-brakeman', require: false
end

copy_file 'Guardfile'
append_file '.gitignore', "Gemfile.tags\n"
append_file '.gitignore', "tags\n"
