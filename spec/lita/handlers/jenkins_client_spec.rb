require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient, lita_handler: true do
  describe '#jenkins_params' do
    before do
      registry.config.handlers.jenkins_client.tap do |config|
        config.username = jenkins_config_hash[:username]
        config.password = jenkins_config_hash[:password]
        config.server_url = jenkins_config_hash[:server_url]
      end
    end

    it 'maps config to a hash param' do
      expect(subject.send(:jenkins_params)[:username]).to eq(jenkins_config_hash[:username])
      expect(subject.send(:jenkins_params)[:password]).to eq(jenkins_config_hash[:password])
      expect(subject.send(:jenkins_params)[:server_url]).to eq(jenkins_config_hash[:server_url])
    end

    it 'validates boolean value if config_type is Object' do
      expect {
        registry.config.handlers.jenkins_client.tap do |config|
          config.ssl = 123 
        end
      }.to raise_error(SystemExit)
    end

    describe '#client' do
      it 'creates a client instance from the param hash' do
        expect(subject.send(:client)).to be_a JenkinsApi::Client
      end
    end
  end

end
