require_relative 'jenkins_client/action'
require_relative 'jenkins_client/base_action'
require_relative 'jenkins_client/job_action'

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
    Lita.register_handler(JenkinsClient::JobAction)
  end
end
