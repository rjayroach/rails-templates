# circleci/tasks/main.rb

append_file '.dockerignore', ".circleci\n" if app.docker?
