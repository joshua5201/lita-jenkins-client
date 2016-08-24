require_relative 'command'
require_relative 'build_param'
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
          list_all: Command.new(name: 'list_all', matcher: 'list_all', help: 'list all jobs.'),
          build: Command.new(name: 'build', matcher: 'build', help: 'build job, params type support: boolean, string, choice.', usage: 'build [job name] [param_key:param_value]'),
          get_build_params: Command.new(name: 'params', matcher: '(?:get_build_)?params', help: 'obtain the build parameters of a job.', usage: 'params [job_name]'),
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
      if res.args.length < 3
        res.reply 'please provide a job name'
        return
      end

      job_name = res.args[2]
      if client.job.exists?(job_name) == false
        res.reply "job #{job_name} not exists" 
        return 
      end
      hash_args = key_value_pair(res.args.slice(3...res.args.length))
      if hash_args.empty? 
        res.reply api_exec { client.job.build(job_name) }
        return 
      end

      begin
        params = parse_build_params(hash_args, client.job.get_build_params(job_name))
        res.reply api_exec { 
          http_status = client.job.build(job_name, params)
          if http_status == '201'
            'Job created. (http status 201)'
          else
            "Something went wrong. (http status: #{http_status})"
          end
        }
      rescue ArgumentError => e
        res.reply e.message
      end
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
      if res.args.length < 3 
        res.reply 'please provide a job name'
        return
      end

      res.reply api_exec { client.job.get_build_params(res.args[2]).inspect }
    end

    def get_console_output(res)
    end

    def get_current_build_number(res)
    end

    def get_current_build_status(res)
    end

    def stop_build(res)
    end

    private
    def parse_build_params(hash_args, build_params)
      params = build_params.map do |param|
        bp = BuildParam.new(param)
        bp.value = hash_args[bp.name]
        bp
      end

      return params.reduce({}) {|res, p| res.merge(p.to_h) }
    end

    def key_value_pair(args)
      args.map { |arg|
        if pair = /([\/\\,\.\w-]+):([\/\\,\.\w-]+)/.match(arg)&.captures
          [pair[0], pair[1]]
        else
          nil
        end
      }.compact.to_h
    end
  end
end
