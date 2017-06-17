desc 'Start an RpcServer that receives requests to GreeterServer at the sample server port'
task grpc: :environment do
  require 'greeter_server'
  s = GRPC::RpcServer.new
  s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
  s.handle(GreeterServer)
  s.handle(HreeterServer)
  s.run_till_terminated
end
