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
      "jenkins exec_cli" => "executes the jenkins cli. usage: jenkins exec_cli [command] "
    })

    route(route_matcher("get_config"), :get_config, :command => true, :help => {
      "jenkins get_config" => "Obtains the configuration of a component from the Jenkins CI server. usage: jenkins get_config [url_prefix (like /job/test_job)]"
    })

    def get_jenkins_version(res)
      res.reply client.get_jenkins_version
    end

    def exec_cli(res)
      if res.args.length < 2
        res.reply 'Error: no command provided'
        return
      end

      res.reply client.exec_cli(res.args.slice(1...res.args.length).join(' '))
    end

    def get_config(res)
      if res.args.length < 2
        res.reply 'Error: no url_prefix provided'
        return
      end

      res.reply client.get_config(res.args[1])
    end

  end
end
