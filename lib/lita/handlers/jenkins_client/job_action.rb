require_relative 'command'
class Lita::Handlers::JenkinsClient < Lita::Handler  
  class JobAction < Lita::Handlers::JenkinsClient::Action
    # Method defined under JenkinsApi::Client::Job
    # @lita jenkins job [command]
    
    namespace "jenkins_client"

    class << self
      def route_prefix
        super + ["job"]
      end

      def commands
        super.merge({
          list_all: Command.new(name: 'list_all', matcher: 'list_all', help: 'list all jobs.')
        })
      end
    end

    def list_all(res)
      res.reply api_exec {
        client.job.list_all.inspect
      }
    end

    def list(res)
    end

    def list_with_details(res)
    end

    def list_all_with_details(res)
    end

    def list_by_status(res)
    end

    def build(res)
    end

    def chain(res)
    end

    def copy(res)
    end

    def delete(res)
    end

    def disable(res)
    end

    def enable(res)
    end

    def exist?(res)
    end

    def get_build_params(res)
    end

    def get_console_output(res)
    end

    def get_current_build_number(res)
    end

    def get_current_build_status(res)
    end

    def stop_build(res)
    end

  end
end
