require "lita-jenkins-client"
require "lita/rspec"
require "psych"
require "byebug"

# A compatibility mode is provided for older plugins upgrading from Lita 3. Since this plugin
# was generated with Lita 4, the compatibility mode should be left disabled.
Lita.version_3_compatibility_mode = false

def jenkins_config_hash
  @config ||= Psych.load_file('spec/config.yml')
end
def jenkins_config_mock
  if @mock 
    return @mock
  end

  @mock = Object.new
  jenkins_config_hash.each do |key, value|
    @mock.define_singleton_method(key) do 
      value
    end
  end
  return @mock 
end

def set_test_jobs
  client = JenkinsApi::Client.new(jenkins_config_hash)
  client.job.create_or_update('test_with_param', File.read('spec/fixtures/test_with_param.xml'))
  client.job.create_or_update('test_without_param', File.read('spec/fixtures/test_without_param.xml'))
end

def delete_test_jobs
  client = JenkinsApi::Client.new(jenkins_config_hash)
  client.job.delete('test_with_param')
  client.job.delete('test_without_param')
end

RSpec.configure do |config|
  config.before(:all) do
    set_test_jobs
  end

  config.after(:all) do
    delete_test_jobs
  end
end

