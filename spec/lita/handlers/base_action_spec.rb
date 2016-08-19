require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::BaseAction, lita_handler: true, additional_lita_handlers: JenkinsClient do
  it { is_expected.to route_command("jenkins version").to(:get_jenkins_version) }
  it { is_expected.to route_command("jenkins get_jenkins_version").to(:get_jenkins_version) }

  it { is_expected.to route_command("jenkins exec_cli").to(:exec_cli) }
  it { is_expected.to route_command("jenkins cli").to(:exec_cli) }
  xit { is_expected.to route_command("jenkins exec_script").to(:exec_script) }

  let! (:client) { JenkinsApi::Client.new(jenkins_config_hash) }

  before do
    registry.config.handlers.jenkins_client.tap do |config|
      config.username = jenkins_config_hash[:username]
      config.password = jenkins_config_hash[:password]
      config.server_url = jenkins_config_hash[:server_url]
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

  describe 'exec_script' do 
    xit 'executes the provided groovy script on the Jenkins CI server' do
    end
  end
end

