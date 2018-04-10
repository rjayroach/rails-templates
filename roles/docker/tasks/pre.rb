copy_file 'docker/files/dockerignore', '.dockerignore'
copy_file 'docker/files/aliases', '.aliases'

template 'docker/templates/Dockerfile', 'Dockerfile'
template 'docker/templates/docker-compose.yml', 'docker-compose.yml'
