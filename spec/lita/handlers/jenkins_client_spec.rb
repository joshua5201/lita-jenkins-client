require "spec_helper"
# frozen_string_literal: true
require "jenkins_api_client"

describe Lita::Handlers::JenkinsClient, lita_handler: true do
  describe '#head_matcher' do
    it 'returns a regex-format String that matches at least first n charactor of a String' do
      method_name = 'command'
      expect(Lita::Handlers::JenkinsClient.head_matcher(method_name)).to eq("c(?:ommand)?")
      expect(Lita::Handlers::JenkinsClient.head_matcher(method_name, 1)).to eq("c(?:ommand)?")
      expect(Lita::Handlers::JenkinsClient.head_matcher(method_name, 2)).to eq("co(?:mmand)?")
      expect(Lita::Handlers::JenkinsClient.head_matcher(method_name, 3)).to eq("com(?:mand)?")
      expect(Lita::Handlers::JenkinsClient.head_matcher(method_name, 6)).to eq("comman(?:d)?")
      expect(Lita::Handlers::JenkinsClient.head_matcher(method_name, 7)).to eq("command")
      expect(Lita::Handlers::JenkinsClient.head_matcher(method_name, 8)).to eq("command")
    end

    it 'aliases to hm' do
      expect(Lita::Handlers::JenkinsClient.method(:hm)).to eq(Lita::Handlers::JenkinsClient.method(:head_matcher))
    end

    it 'also accepts a Symbol' do
      expect(Lita::Handlers::JenkinsClient.hm(:foobar)).to eq(Lita::Handlers::JenkinsClient.hm('foobar'))
    end

  end
end
