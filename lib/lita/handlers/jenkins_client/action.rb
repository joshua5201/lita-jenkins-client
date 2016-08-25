require_relative 'command'
require 'byebug'
class Lita::Handlers::JenkinsClient < Lita::Handler  
  class Action < Lita::Handlers::JenkinsClient
    namespace "jenkins_client"

    class << self
      protected 

      def route_prefix
        ["jenkins"]
      end
      
      def route_matcher(actions)
        Regexp.new('^'+(route_prefix + [actions].flatten).join(' ').strip, 'i')
      end

      def name_prefix
        route_prefix.join(' ')
      end

      def commands
        {}
      end 

      def method_added(name)
        if self == Lita::Handlers::JenkinsClient::Action
          return
        end
        if cmd = commands[name]
          route(route_matcher(cmd.matcher), name, :command => true, :help => {
            "#{name_prefix} #{cmd.name}" => "#{cmd.help} Usage: #{name_prefix} #{cmd.usage}"
          })
        end
      end

    end

    protected

    def api_exec(usage = nil) 
      if block_given?
        begin 
          yield
        rescue Exception => e
          "Error: #{e.message}" + (usage ? " Usage: #{usage}" : '') 
        end
      end
    end

    def usage(name)
      self.class.commands[name].usage
    end
  end
end
