require "spec_helper"
require "jenkins_api_client"

describe Lita::Handlers::JenkinsClient::BaseAction, lita_handler: true do
  it { is_expected.to route("jenkins get_jenkins_version") }

  let(:subject_class) { Lita::Handlers::JenkinsClient::BaseAction }

  describe 'class methods' do
    describe '#route_matcher' do
      it 'adds a prefix to action name' do
        expect(subject_class.send(:route_matcher, "foo")).to eq("jenkins foo")
      end

      it 'also accepts array as parameter' do
        expect(subject_class.send(:route_matcher, ["foo", "bar"])).to eq("jenkins foo bar")
      end
    end
  end
end

