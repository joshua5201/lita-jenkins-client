class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BaseAction < Lita::Handlers::JenkinsClient::Action
    # 1. Method defined under JenkinsApi::Client
    # 2. Convenience custom commands
    # @lita jenkins [command]
    
    namespace 'jenkins_client'

    route(route_matcher("(?:get_jenkins_)?version"), :get_jenkins_version, :command => true, :help => {
      "jenkins version" => "get jenkins version"
    })

    route(route_matcher("(?:api_)?get(?:_request)?"), :api_get_request, :command => true, :help => {
      "jenkins get" => "api get request url_prefix [tree = nil] [url_suffix = /api/json] [raw_response = false]"
    })

    def get_jenkins_version(res)
      res.reply client.get_jenkins_version
    end

    def api_get_request(res)
      if res.args.length < 2 
        res.reply "Error: url_prefix should be set"
        res.reply "Example: jenkins [get | api_get_request] /me/my-views/view/All"
      else
        res.reply client.api_get_request(res.args[1]).to_s
      end
    end
  end
end
