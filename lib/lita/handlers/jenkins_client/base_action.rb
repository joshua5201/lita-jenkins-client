require_relative 'command'
class Lita::Handlers::JenkinsClient < Lita::Handler  
  class BaseAction < Lita::Handlers::JenkinsClient::Action
    # 1. Method defined under JenkinsApi::Client
    # 2. Convenience custom commands
    # @lita jenkins [command]
    
    namespace 'jenkins_client'

    def self.commands
      super.merge ({
        version: Command.new(name: 'version', matcher: 'version', help: 'get jenkins version.'),
        cli: Command.new(name: 'cli', matcher: 'cli', help: 'executes the jenkins cli.', usage: 'cli [command]'),
        running?: Command.new(name: 'running?', matcher: 'running\?', help: 'Show if jenkins is running.'),
      })
    end

    def version(res)
      res.reply api_exec { 
        client.get_jenkins_version
      }
    end

    def cli(res)
      if res.args.length < 2
        res.reply 'Please provide at least one command'
        return 
      end
      res.reply api_exec(usage(:cli)) { 
        client.exec_cli(res.args.slice(1...res.args.length).join(' '))
      }
    end

    def running?(res)
      res.reply api_exec { 
        client.get_root.inspect
        "Running"
      }
    end

  end
end
