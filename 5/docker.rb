template 'docker/Dockerfile', 'Dockerfile'
copy_file 'docker/dockerignore', '.dockerignore'
template 'docker/docker-compose.yml', 'docker-compose.yml'
template 'docker/aliases', '.aliases'
