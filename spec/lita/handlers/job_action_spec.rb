require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::JobAction, lita_handler: true, additional_lita_handlers: JenkinsClient do
  it { is_expected.to route_command('jenkins job list_all').to(:list_all) }
  it { is_expected.to route_command('jenkins job build').to(:build) }
  let! (:client) { JenkinsApi::Client.new(jenkins_config_hash) }

  before do
    registry.config.handlers.jenkins_client.tap do |config|
      config.username = jenkins_config_hash[:username]
      config.password = jenkins_config_hash[:password]
      config.server_url = jenkins_config_hash[:server_url]
      config.log_level = jenkins_config_hash[:log_level]
    end
  end

  describe '#list_all' do
    it 'returns list of jobs' do
      send_command('jenkins job list_all')
      expect(replies.last).to eq(client.job.list_all.inspect)
    end
  end

  describe '#build' do
    it 'builds job without parameters' do
    end
  end

end
