append_to_file '.dockerignore', File.read("#{template_dir}/roles/docker/files/dockerignore")
copy_file 'docker/files/aliases', '.aliases'

template 'docker/templates/Dockerfile', 'Dockerfile'
template 'docker/templates/docker-compose.yml', 'docker-compose.yml'
