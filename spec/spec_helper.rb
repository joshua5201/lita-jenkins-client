require 'simplecov'
SimpleCov.start

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

def set_test_jobs
  client = JenkinsApi::Client.new(jenkins_config_hash)
  client.job.create_or_update('test_with_params', File.read('spec/fixtures/test_with_params.xml'))
  client.job.create_or_update('test_without_params', File.read('spec/fixtures/test_without_params.xml'))
end

def delete_test_jobs
  client = JenkinsApi::Client.new(jenkins_config_hash)
  client.job.delete('test_with_params')
  client.job.delete('test_without_params')
end

RSpec.configure do |config|
  config.before(:suite) do
    set_test_jobs
  end

  config.after(:suite) do
    delete_test_jobs
  end
end

