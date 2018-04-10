append_file '.gitignore', ".env\n"
append_file '.gitignore', ".env.local\n"
append_file '.gitignore', "#{dummy_path}/Gemfile.lock\n" if app.plugin?
git add: '.'
git commit: "-a -m 'Initial commit'"
