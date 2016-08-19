require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::BaseAction, lita_handler: true, additional_lita_handlers: JenkinsClient do
  it { is_expected.to route_command("jenkins version").to(:get_jenkins_version) }
  it { is_expected.to route_command("jenkins get_jenkins_version").to(:get_jenkins_version) }

  it { is_expected.to route_command("jenkins get").to(:api_get_request) }
  it { is_expected.to route_command("jenkins api_get_request").to(:api_get_request) }

  let! (:client) { JenkinsApi::Client.new(jenkins_config_hash) }

  describe '#get_jenkins_version' do
    before do
      registry.config.handlers.jenkins_client.tap do |config|
        config.username = jenkins_config_hash[:username]
        config.password = jenkins_config_hash[:password]
        config.server_url = jenkins_config_hash[:server_url]
      end
    end
    it 'replies jenkins version' do
      send_command('jenkins version');
      expect(replies.last).to eq(client.get_jenkins_version)
    end
  end
end

