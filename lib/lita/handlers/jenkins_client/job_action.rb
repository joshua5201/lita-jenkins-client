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
          all: Command.new(name: 'all', matcher: 'all', help: 'list all jobs.'),
          list: Command.new(name: 'list', matcher: 'list', help: 'list jobs matching pattern.', usage: 'list [filter]'),
          list_by_status: Command.new(name: 'list_by_status', matcher: 'list_by_status', help: 'list jobs with certain status.', usage: 'list_by_status [success/failure]'),
          status: Command.new(name: 'status', matcher: 'status', help: 'print job status.', usage: 'status [job name]'),
          build: Command.new(name: 'build', matcher: 'build', help: "build job, #{BuildParam.print_supported_types}", usage: 'build [job name] [param_key:param_value]'),
          params: Command.new(name: 'params', matcher: 'params', help: 'obtain the build parameters of a job.', usage: 'params [job_name]'),
          exists?: Command.new(name: 'exists?', matcher: 'exists\?', help: 'check if a job exists', usage: 'exists [job name]'),
        })
      end
    end

    def all(res)
      res.reply api_exec {
        client.job.list_all.inspect
      }
    end

    def list(res)
      if res.args.length < 3
        res.reply 'please provide a search condition'
        return
      end

      res.reply api_exec { client.list(res.args[2]) }
    end

    def list_by_status(res)
      if res.args.length < 3
        res.reply 'please provide a status ( SUCCESS, FAILURE )'
        return
      end
      
      res.reply api_exec { client.list_by_status(res.args[2]) }
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
        res.reply api_exec { 
          print_build_status(client.job.build(job_name))
        }
        return 
      end

      begin
        params = parse_build_params(hash_args, client.job.get_build_params(job_name))
        res.reply api_exec { 
          print_build_status(client.job.build(job_name, params))
        }
      rescue ArgumentError => e
        res.reply "Error: #{e.message}"
      end
    end

    def delete(res)
      if res.args.length < 3 
        res.reply 'please provide a job name'
        return
      end

      res.reply api_exec { client.job.delete(res.args[2]).inspect }
    end

    def status(res)
      if res.args.length < 3 
        res.reply 'please provide a job name'
        return
      end

      res.reply api_exec { client.job.get_current_build_status(res.args[2]).inspect }
    end

    def exists?(res)
      if res.args.length < 3
        res.reply 'please provide a job name'
        return
      end

      res.reply api_exec { client.job.exists?(res.args[2]).inspect }
    end

    def params(res)
      if res.args.length < 3 
        res.reply 'please provide a job name'
        return
      end

      res.reply api_exec { client.job.get_build_params(res.args[2]).inspect }
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

    def print_build_status(status)
      if status == '201'
        'Job created. (http status 201)'
      else
        "Something went wrong. (http status: #{status})"
      end
    end
  end
end
