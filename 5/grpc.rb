
gem 'grpc'
gem 'grpc-tools'
gem 'protobuf-activerecord'

empty_directory 'app/messages'
empty_directory 'app/protos'

template 'grpc/grpc.rake', 'lib/tasks/grpc.rake'
