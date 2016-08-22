require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::BaseAction, lita_handler: true, additional_lita_handlers: JenkinsClient do
  it { is_expected.to route_command("jenkins version").to(:get_jenkins_version) }
  it { is_expected.to route_command("jenkins get_jenkins_version").to(:get_jenkins_version) }

  it { is_expected.to route_command("jenkins running?").to(:get_root) }

  it { is_expected.to route_command("jenkins exec_cli").to(:exec_cli) }
  it { is_expected.to route_command("jenkins cli").to(:exec_cli) }

  it { is_expected.to route_command("jenkins get_config").to(:get_config) }

  let! (:client) { JenkinsApi::Client.new(jenkins_config_hash) }

  before do
    registry.config.handlers.jenkins_client.tap do |config|
      config.username = jenkins_config_hash[:username]
      config.password = jenkins_config_hash[:password]
      config.server_url = jenkins_config_hash[:server_url]
      config.log_level = jenkins_config_hash[:log_level]
    end
  end

  describe '#get_jenkins_version' do
    it 'replies jenkins version' do
      send_command('jenkins version');
      expect(replies.last).to eq(client.get_jenkins_version)
    end
  end

  describe '#exec_cli' do
    it 'executes the Jenkins CLI' do
      send_command('jenkins exec_cli list-plugins git') 
      expect(replies.last).to eq(client.exec_cli('list-plugins git'))
    end
  end

  describe '#get_config' do
    it 'gets jenkins config file according to url_prefix' do
      send_command("jenkins get_config /job/test_with_param")
      expect(replies.last).to eq(client.get_config("/job/test_with_param"))
    end
  end

  describe '#running?' do
    it 'returns Running when jenkins running' do
      send_command('jenkins running?') 
      expect(replies.last).to eq("Running")
    end
  end

end
