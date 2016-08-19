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
