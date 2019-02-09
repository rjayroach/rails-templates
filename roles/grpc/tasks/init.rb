
app.gem 'grpc'
app.gem 'grpc-tools'
app.gem 'protobuf-activerecord'

empty_directory 'app/messages'
empty_directory 'app/protos'

template 'grpc/files/grpc.rake', 'lib/tasks/grpc.rake'

append_file 'Procfile', "grpc:    bundle exec rake grpc\n"
