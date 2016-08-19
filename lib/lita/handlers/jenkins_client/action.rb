class Lita::Handlers::JenkinsClient < Lita::Handler  
  class Action < Lita::Handlers::JenkinsClient
    namespace "jenkins_client"

    class << self
      def route_prefix
        ["^jenkins"]
      end

      def route_matcher(actions)
        Regexp.new((route_prefix + [actions].flatten).reduce("") { |res, str| res + str + " "}.strip, 'i')
      end
    end

  end
end
