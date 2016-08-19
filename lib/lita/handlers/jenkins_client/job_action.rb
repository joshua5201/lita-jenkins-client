class Lita::Handlers::JenkinsClient < Lita::Handler  
  class JobAction < Lita::Handlers::JenkinsClient::Action
    # Method defined under JenkinsApi::Client::Job
    # @lita jenkins job [command]
    
    class << self
      def route_prefix
        super + ["job"]
      end
    end

  end
end
