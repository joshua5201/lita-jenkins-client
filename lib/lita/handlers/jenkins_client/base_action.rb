class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BaseAction < Lita::Handlers::JenkinsClient::Action
    # 1. Method defined under JenkinsApi::Client
    # 2. Convenience custom commands
    # @lita jenkins [command]
    
    namespace 'jenkins_client'

    route(route_matcher("(?:get_jenkins_)?version"), :get_jenkins_version, :command => true, :help => {
      "jenkins version" => "get jenkins version"
    })

    route(route_matcher("(?:exec_)?cli"), :exec_cli, :command => true, :help => {
      "jenkins exec_cli" => "executes the jenkins cli"
    })

    def get_jenkins_version(res)
      res.reply client.get_jenkins_version
    end

    def exec_cli(res)
      if res.args.length < 2
        res.reply 'Error: no command specified'
        return
      end

      res.reply client.exec_cli(res.args.slice(1...res.args.length).join(' '))
    end

  end
end
