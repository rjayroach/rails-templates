
template 'circleci/templates/config.yml', '.circleci/config.yml'
append_file '.dockerignore', ".circleci\n" if app.docker?
