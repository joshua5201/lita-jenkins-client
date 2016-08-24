require_relative 'command'
class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BaseAction < Lita::Handlers::JenkinsClient::Action
    # 1. Method defined under JenkinsApi::Client
    # 2. Convenience custom commands
    # @lita jenkins [command]
    
    namespace 'jenkins_client'

    def self.commands
      super.merge ({
        get_jenkins_version: Command.new(name: 'version', matcher: '(?:get_jenkins_)?version', help: 'get jenkins version.'),
        exec_cli: Command.new(name: 'cli', matcher: '(?:exec_)?cli', help: 'executes the jenkins cli.', usage: 'cli [command]'),
        get_root: Command.new(name: 'running?', matcher: 'running\?', help: 'Show if jenkins is running.'),
      })
    end

    def get_jenkins_version(res)
      res.reply api_exec { 
        client.get_jenkins_version
      }
    end

    def exec_cli(res)
      if res.args.length < 2
        res.reply 'Please provide at least one command'
        return 
      end
      res.reply api_exec(usage(:exec_cli)) { 
        client.exec_cli(res.args.slice(1...res.args.length).join(' '))
      }
    end

    def get_root(res)
      res.reply api_exec { 
        client.get_root.inspect
        "Running"
      }
    end

  end
end
