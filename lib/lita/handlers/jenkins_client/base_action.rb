class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BaseAction < Lita::Handlers::JenkinsClient
    namespace "jenkins_client"

    class << self
      def route_prefix
        ["jenkins"]
      end

      def route_matcher(actions)
        (route_prefix + [actions].flatten).reduce("") { |res, str| res + str + " "}.strip
      end
    end

    route(route_matcher("get_jenkins_version"), :get_jenkins_version, :help => {
      "echo TEXT" => "get jenkins version"
    })

    def get_jenkins_version(res)
      client = set_client
      res.reply client.get_jenkins_version
    end
  end
end
