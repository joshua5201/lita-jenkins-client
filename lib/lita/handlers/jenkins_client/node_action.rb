class Lita::Handlers::JenkinsClient < Lita::Handler  
  class NodeAction < Lita::Handlers::JenkinsClient::Action
    # Method defined under JenkinsApi::Client::Node
    # @lita jenkins node [command]
    
    class << self
      def route_prefix
        super + ["node"]
      end
    end


  end
end
