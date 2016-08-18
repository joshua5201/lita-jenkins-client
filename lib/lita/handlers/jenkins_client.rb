# frozen_string_literal: true
module Lita
  module Handlers
    class JenkinsClient < Handler
      namespace 'jenkins_client'

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

      CONFIGS = { 
        server_url: String,
        server_ip: String,
        server_port: String,
        proxy_ip: String,
        proxy_port: String,
        jenkins_path: String,
        username: String,
        password: String,
        password_base64: String,
        log_location: String,
        log_level: Fixnum,
        timeout: Fixnum,
        ssl: Boolean,
        follow_redirects: Boolean,
        identity_file: String,
        cookies: String
      }.freeze

      params = CONFIGS.map { |config_name, config_type|
        config config_name, type: config_type 
        if Lita.config.send(config_name)
          return [config_name, Lita.config.send(config_name)]
        else
          []
        end
      }.to_h

      @@client = JenkinsApi::Client.new(params)

      Lita.register_handler(self)
    end
  end
end
