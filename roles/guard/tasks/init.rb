gem_group :development do
  gem 'guard-rspec', require: false
  gem 'guard-livereload', require: false
  gem 'guard-ctags-bundler', require: false
  gem 'guard-brakeman', require: false
end

if app.rubocop?
  gem_group :development do
    gem 'guard-rubocop', require: false
  end
end

copy_file 'guard/files/Guardfile', 'Guardfile'
app.content_files << 'Guardfile'
