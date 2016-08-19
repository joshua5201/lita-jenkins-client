require_relative 'jenkins_client/action'
require_relative 'jenkins_client/base_action'

module Lita
  module Handlers
    class JenkinsClient < Handler
      namespace 'jenkins_client'

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
        ssl: Object,
        follow_redirects: Object,
        identity_file: String,
        cookies: String
      }.freeze

      CONFIGS.each do |config_name, config_type|
        config config_name, type: config_type 
        if config_type == Object
          config config_name do 
            validate do |value|
              value.in? [true, false, nil]
            end
          end
        end
      end

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

      protected
      def jenkins_params 
        CONFIGS.keys.select{|key| config.respond_to?(key)}.map{|key| [key, config.send(key)] }.to_h
      end

      def client
        @client ||= JenkinsApi::Client.new(jenkins_params)
      end
    end

    Lita.register_handler(JenkinsClient)
    Lita.register_handler(JenkinsClient::Action)
    Lita.register_handler(JenkinsClient::BaseAction)
  end
end
