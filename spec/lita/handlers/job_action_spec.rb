require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::JobAction, lita_handler: true, additional_lita_handlers: JenkinsClient do
  it { is_expected.to route('jenkins job all').to(:all) }
  it { is_expected.to route('jenkins job list').to(:list) }
  it { is_expected.to route('jenkins job status').to(:status) }
  it { is_expected.to route('jenkins job build').to(:build) }
  it { is_expected.to route('jenkins job exists?').to(:exists?) }
  it { is_expected.to route('jenkins job params').to(:params) }
  let! (:client) { JenkinsApi::Client.new(jenkins_config_hash) }

  before do
    registry.config.handlers.jenkins_client.tap do |config|
      config.username = jenkins_config_hash[:username]
      config.password = jenkins_config_hash[:password]
      config.server_url = jenkins_config_hash[:server_url]
      config.log_level = jenkins_config_hash[:log_level]
    end
  end

  describe '#all' do
    it 'returns list of jobs' do
      send_message('jenkins job all')
      expect(replies.last).to eq(client.job.list_all.inspect)
    end
  end


  describe '#build' do
    it 'ends when no input' do
      send_message('jenkins job build')
      expect(replies.last).to eq("please provide a job name")
    end

    it 'ends when job not exists' do
      send_message('jenkins job build not_exist')
      expect(replies.last).to eq("job not_exist not exists")
    end

    it 'builds job without parameters' do
      send_message('jenkins job build test_without_params')
      expect(replies.last).to eq("Job created. (http status 201)")
    end

    it 'builds job with parameters' do
      send_message('jenkins job build test_with_params bool:true choice:c foo:foobar')
      expect(replies.last).to eq("Job created. (http status 201)")
    end

    it 'reply error message when ArgumentError' do
      send_message('jenkins job build test_with_params bool:abc choice:c foo:foobar')
      expect(replies.last).to eq('Error: bool should be true or false')
    end
  end

  describe '#parse_build_params' do
    let(:build_params) { build_params = [{:type=>"boolean", :name=>"bool", :description=>"", :default=>"true"}, {:type=>"choice", :name=>"choice", :description=>"", :choices=>["a", "b", "c", "d"]}, {:type=>"string", :name=>"foo", :description=>"", :default=>"bar"}] }
    let(:params) { {'bool' => true, 'choice' => 'c', 'foo' => 'foobar'} }

    it 'parses valid args to valid build params' do
      hash_args = {'bool' => 'true', 'choice' => 'c', 'foo' => 'foobar'}
      expect(subject.send(:parse_build_params, hash_args, build_params)).to eq(params)
    end
  end

  describe '#key_value_pair' do
    it 'parses key:value string pairs to hash' do
      input = ['foo:bar', 'test:true', 'ignored']
      expect(subject.send(:key_value_pair, input)).to eq({'foo' => 'bar', 'test' => 'true'})
    end
  end

  describe '#params' do
    it 'obtains job info' do
      send_message('jenkins job params test_with_params')
      expect(replies.last).to eq(client.job.get_build_params('test_with_params').inspect)
    end

    it 'ends when no input' do
      send_message('jenkins job params')
      expect(replies.last).to eq('please provide a job name')
    end
  end

  describe '#exists?' do
    it 'shows if job exists' do
      send_message('jenkins job exists? test_with_params')
      expect(replies.last).to eq(client.job.exists?('test_with_params').inspect)
    end

    it 'ends when no input' do
      send_message('jenkins job exists?')
      expect(replies.last).to eq('please provide a job name')
    end
  end

  describe '#status' do
    it 'shows job status' do
      send_message('jenkins job status test_with_params')
      expect(replies.last).to eq(client.job.get_current_build_status('test_with_params').inspect)
    end

    it 'ends when no input' do
      send_message('jenkins job exists?')
      expect(replies.last).to eq('please provide a job name')
    end
  end
end
