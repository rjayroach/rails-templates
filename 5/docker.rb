copy_file 'docker/Dockerfile', 'Dockerfile'
copy_file 'docker/dockerignore', '.dockerignore'
copy_file 'docker/docker-compose.yml', 'docker-compose.yml'
template 'docker/aliases', '.aliases'
