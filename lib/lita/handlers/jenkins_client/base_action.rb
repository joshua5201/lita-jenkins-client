class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BaseAction < Lita::Handlers::JenkinsClient::Action
    # 1. Method defined under JenkinsApi::Client
    # 2. Convenience custom commands
    # @lita jenkins [command]
    
    namespace 'jenkins_client'

    route(route_matcher("(?:get_jenkins_)?version"), :get_jenkins_version, :command => true, :help => 
      "lita jenkins version: get jenkins version"
    )

    route(route_matcher("(?:api_)?get(?:_request)?"), :api_get_request, :command => true, :help =>
      "lita jenkins get: api get request url_prefix [tree = nil] [url_suffix = /api/json] [raw_response = false]"
    )

    def get_jenkins_version(res)
      res.reply client.get_jenkins_version
    end

    def api_get_request(res)
      if args.length < 1
        res.reply "Error: url_prefix should be set"
        res.reply "Example: jenkins get / api_get_request jobs"
      else
        client.api_get_request(args[0])
      end
    end
  end
end
