
append_file '.env', "DOCKER_IMAGE_NAME=quay.io/#{app.application_name}\n"
append_file '.env', "DOCKER_IMAGE_TAG=0.0.1\n"
append_file '.env', "COMPOSE_PROJECT_NAME=#{app.application_name}\n"
