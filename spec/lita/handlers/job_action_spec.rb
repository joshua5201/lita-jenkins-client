require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::JobAction, lita_handler: true, additional_lita_handlers: JenkinsClient do
  it { is_expected.to route_command('jenkins job list_all').to(:list_all) }
  it { is_expected.to route_command('jenkins job build').to(:build) }
  it { is_expected.to route_command('jenkins job params').to(:get_build_params) }
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
    it 'ends when no input' do
      send_command('jenkins job build')
      expect(replies.last).to eq("please provide a job name")
    end

    it 'ends when job not exists' do
      send_command('jenkins job build not_exist')
      expect(replies.last).to eq("job not_exist not exists")
    end

    it 'builds job without parameters' do
      send_command('jenkins job build test_without_params')
      expect(replies.last).to eq(client.job.build('test_without_params'))
    end

    it 'builds job with parameters' do
    end

    it 'ignores parameters not in key:value pattern' do
    end
  end

  describe '#parse_build_params' do
    it 'parses key:value pairs to param hash according to the input hash' do
    end
  end

  describe '#get_build_params' do
    it 'obtains job info' do
      send_command('jenkins job params test_with_params')
      expect(replies.last).to eq(client.job.get_build_params('test_with_params').inspect)
    end

    it 'ends when no input' do
      send_command('jenkins job params')
      expect(replies.last).to eq('please provide a job name')
    end
  end

end
