require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::Action, lita_handler: true, additional_lita_handlers: JenkinsClient do
  let(:subject_class) { Lita::Handlers::JenkinsClient::Action }

  describe 'class methods' do
    describe '#route_matcher' do
      it 'adds a prefix to action name' do
        expect(subject_class.send(:route_matcher, "foo")).to eq(Regexp.new('^jenkins foo\b', 'i'))
      end

      it 'also accepts array as parameter' do
        expect(subject_class.send(:route_matcher, ["foo", "bar"])).to eq(Regexp.new('^jenkins foo bar\b', 'i'))
      end
    end
  end

  describe '#api_exec' do
    it 'returns block output' do
      expect(subject.send(:api_exec) { 'output' }).to eq('output')
    end

    it 'returns error message when error raised' do
      expect(subject.send(:api_exec) { raise Exception, 'test error.' }).to eq('Error: test error.')
    end

    it 'appends an usage message after error message if usage given' do
      expect(subject.send(:api_exec, 'test usage') { 
        raise Exception, 'test error.' 
      }).to eq('Error: test error. Usage: test usage')
    end
  end

end
