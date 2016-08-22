require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::Action, lita_handler: true, additional_lita_handlers: JenkinsClient do
  let(:subject_class) { Lita::Handlers::JenkinsClient::Action }

  describe 'class methods' do
    describe '#route_matcher' do
      it 'adds a prefix to action name' do
        expect(subject_class.send(:route_matcher, "foo")).to eq(Regexp.new("^jenkins foo", 'i'))
      end

      it 'also accepts array as parameter' do
        expect(subject_class.send(:route_matcher, ["foo", "bar"])).to eq(Regexp.new("^jenkins foo bar", 'i'))
      end
    end
  end

end
