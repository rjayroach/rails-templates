copy_file 'docker/files/dockerignore', '.dockerignore'
copy_file 'docker/files/aliases', '.aliases'
copy_file 'docker/files/inputrc', '.inputrc'

template 'docker/templates/Dockerfile', 'Dockerfile'
template 'docker/templates/docker-compose.yml', 'docker-compose.yml'
template 'docker/templates/docker-compose-dev.yml', 'docker-compose-dev.yml'
