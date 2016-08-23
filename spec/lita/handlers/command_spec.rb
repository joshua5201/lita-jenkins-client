require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::Command do
  describe '#initialize' do
    it 'can be initialized with usage' do
      command = described_class.new(name: 'testname', matcher: 'testmatcher', help: 'testhelp', usage: 'testusage')
      expect(command).to be_a JenkinsClient::Command
    end

    it 'can be initialized without usage' do
      command = described_class.new(name: 'testname', matcher: 'testmatcher', help: 'testhelp')
      expect(command).to be_a JenkinsClient::Command
    end

    it 'has @usage equals to @name when no usage param provided' do
      command = described_class.new(name: 'testname', matcher: 'testmatcher', help: 'testhelp')
      expect(command.usage).to eq(command.name)
    end
  end
end
