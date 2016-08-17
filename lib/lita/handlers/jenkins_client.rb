module Lita
  module Handlers
    class JenkinsClient < Handler
      class << self
        def head_matcher(s, n = 1)
          str = s.to_s 
          if n >= str.length
            str
          else
            "#{str.slice(0, n)}(?:#{str.slice(n, str.length)})?"
          end
        end

        alias_method :hm, :head_matcher
      end

      METHODS = [:queue, :job, :node, :plugin, :system, :user, :view, :exec_cli, :exec_script]
      METHODS.each do |method_name|
        define_method(method_name) do
          reply method_name.to_s
        end

        route(Regexp.new("#{hm("jenkins")} #{hm(method_name)}"), method_name)
      end


      Lita.register_handler(self)
    end
  end
end
