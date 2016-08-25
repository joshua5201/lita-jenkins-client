require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::BaseAction, lita_handler: true, additional_lita_handlers: JenkinsClient do
  it { is_expected.to route("jenkins version").to(:version) }
  it { is_expected.to route("jenkins running?").to(:running?) }
  it { is_expected.to route("jenkins cli").to(:cli) }

  let! (:client) { JenkinsApi::Client.new(jenkins_config_hash) }

  before do
    registry.config.handlers.jenkins_client.tap do |config|
      config.username = jenkins_config_hash[:username]
      config.password = jenkins_config_hash[:password]
      config.server_url = jenkins_config_hash[:server_url]
      config.log_level = jenkins_config_hash[:log_level]
    end
  end

  describe '#version' do
    it 'replies jenkins version' do
      send_message('jenkins version');
      expect(replies.last).to eq(client.get_jenkins_version)
    end
  end

  describe '#cli' do
    it 'executes the Jenkins CLI', :cli_test => true do
      send_message('jenkins cli list-plugins git') 
      expect(replies.last).to eq(client.exec_cli('list-plugins git'))
    end
    it 'ends when no commands provides' do
      send_message('jenkins cli ') 
      expect(replies.last).to eq('Please provide at least one command')
    end
  end

  describe '#running?' do
    it 'returns Running when jenkins running' do
      send_message('jenkins running?') 
      expect(replies.last).to eq("Running")
    end
  end

end
