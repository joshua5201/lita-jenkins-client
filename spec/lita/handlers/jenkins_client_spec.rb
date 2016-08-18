require "spec_helper"
require "jenkins_api_client"

describe Lita::Handlers::JenkinsClient, lita_handler: true do
  let(:subject_class) { Lita::Handlers::JenkinsClient }

  describe '#head_matcher' do
    it 'returns a regex-format String that matches at least first n charactor of a String' do
      method_name = 'command'
      expect(subject_class.head_matcher(method_name)).to eq("c(?:ommand)?")
      expect(subject_class.head_matcher(method_name, 1)).to eq("c(?:ommand)?")
      expect(subject_class.head_matcher(method_name, 2)).to eq("co(?:mmand)?")
      expect(subject_class.head_matcher(method_name, 3)).to eq("com(?:mand)?")
      expect(subject_class.head_matcher(method_name, 6)).to eq("comman(?:d)?")
      expect(subject_class.head_matcher(method_name, 7)).to eq("command")
      expect(subject_class.head_matcher(method_name, 8)).to eq("command")
    end

    it 'aliases to hm' do
      expect(subject_class.method(:hm)).to eq(subject_class.method(:head_matcher))
    end

    it 'also accepts a Symbol' do
      expect(subject_class.hm(:foobar)).to eq(subject_class.hm('foobar'))
    end
  end

  describe '#jenkins_params' do
    it 'maps config to a hash param' do
      allow(subject).to receive(:config) { jenkins_config_mock }
      expect(subject.send(:jenkins_params)).to eq(jenkins_config_hash)
    end
  end

  describe '#set_client' do
    it 'creates a client instance from the param hash' do
      allow(subject).to receive(:jenkins_params) { jenkins_config_hash }
      expect(subject.send(:set_client)).to be_a JenkinsApi::Client
    end
  end
end
