# guard/tasks/main.rb

append_file '.gitignore', "Gemfile.tags\n"
append_file '.gitignore', "tags\n"

append_file 'Procfile', "guard:    bundle exec guard\n"
append_file '.dockerignore', "Guardfile\n" if app.docker?
