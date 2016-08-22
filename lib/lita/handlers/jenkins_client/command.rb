class Lita::Handlers::JenkinsClient < Lita::Handler  
  class Command
    attr_reader :name, :matcher, :help, :usage
    def initialize(name: , matcher: , help: , usage: '')
      @name, @matcher, @help = name, matcher, help
      @usage = usage ? usage : name
    end
  end
end
