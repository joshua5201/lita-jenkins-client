require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient, lita_handler: true do
  describe '#head_matcher' do
    it 'returns a regex-format String that matches at least first n charactor of a String' do
      method_name = 'command'
      expect(described_class.head_matcher(method_name)).to eq("c(?:ommand)?")
      expect(described_class.head_matcher(method_name, 1)).to eq("c(?:ommand)?")
      expect(described_class.head_matcher(method_name, 2)).to eq("co(?:mmand)?")
      expect(described_class.head_matcher(method_name, 3)).to eq("com(?:mand)?")
      expect(described_class.head_matcher(method_name, 6)).to eq("comman(?:d)?")
      expect(described_class.head_matcher(method_name, 7)).to eq("command")
      expect(described_class.head_matcher(method_name, 8)).to eq("command")
    end

    it 'aliases to hm' do
      expect(described_class.method(:hm)).to eq(described_class.method(:head_matcher))
    end

    it 'also accepts a Symbol' do
      expect(described_class.hm(:foobar)).to eq(described_class.hm('foobar'))
    end
  end

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
  end

  describe '#client' do
    it 'creates a client instance from the param hash' do
      expect(subject.send(:client)).to be_a JenkinsApi::Client
    end
  end
end
