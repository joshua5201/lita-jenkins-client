require "spec_helper"
require "jenkins_api_client"

include Lita::Handlers
describe JenkinsClient::BuildParam do
  let (:boolean_param) { described_class.new(type: 'boolean', name: 'test', description: 'foobar', default: 'true') } 
  let (:string_param) { described_class.new(type: 'string', name: 'test', description: 'foobar', default: 'testdefault') }
  let (:choice_param) { described_class.new(type: 'choice', name: 'test', description: 'foobar', choices: ['a', 'b', 'c']) }
  describe '#initialize' do
    it 'initializes boolean type param' do
      expect(boolean_param.type).to eq('boolean')
      expect(boolean_param.name).to eq('test')
      expect(boolean_param.default).to eq('true')
      expect(boolean_param.description).to eq('foobar')
    end

    it 'initializes string type param' do
      expect(string_param.type).to eq('string')
    end

    it 'sets value to default' do
      expect(string_param.value).to eq('testdefault')
    end

    it 'initializes choice type param' do
      expect(choice_param.type).to eq('choice')
    end

    it 'set default to first choice when type is choice' do
      expect(choice_param.default).to eq('a')
    end

    it 'raises error when type is not supported' do
      expect { 
        described_class.new(type: 'wrong', name: 'test', description: 'foobar', choices: ['a', 'b', 'c'])
      }.to raise_error(ArgumentError)
    end
  end

  describe '#value=' do
    it 'sets @value to nil if v nil' do
      string_param.value = nil
      expect(string_param.value).to be(nil)
    end

    it 'ends if input not a String' do
      expect { string_param.value = 123 }.not_to change{string_param.value}
    end

    describe 'it sets @value according to type' do
      it 'sets string' do
        string_param.value = "new_string"
        expect(string_param.value).to eq("new_string")
      end

      it 'sets boolean to true' do
        boolean_param.value = "true"
        expect(boolean_param.value).to be true
      end

      it 'sets boolean to false' do
        boolean_param.value = "false"
        expect(boolean_param.value).to be false
      end

      it 'raises error when not a boolean string' do
        expect { boolean_param.value = "something wrong" }.to raise_error(ArgumentError)
      end

      it 'sets choice' do
        choice_param.value = 'b'
        expect(choice_param.value).to eq('b')
      end

      it 'raises error when not in choices' do
        expect { choice_param.value = 'e' }.to raise_error(ArgumentError)
      end

      it 'raises error when type not supported' do
        string_param.instance_variable_set(:@type, 'foo')
        expect { string_param.value = 'raise' }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#to_h' do
  end
end
