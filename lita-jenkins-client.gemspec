Gem::Specification.new do |spec|
  spec.name          = "lita-jenkins-client"
  spec.version       = "0.1.2"
  spec.authors       = ["Tsung-en Hsiao"]
  spec.email         = ["joshua841025@gmail.com"]
  spec.summary = 'Lita jenkins handler that use the jenkins_api_client gem'
  spec.description = "Lita jenkins handler that use the jenkins_api_client gem.  I've implement some commands which is usable now."
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }
  spec.homepage      = 'https://github.com/joshua5201/lita-jenkins-client' 

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'
  spec.add_runtime_dependency "lita", ">= 4.7"
  spec.add_runtime_dependency "jenkins_api_client", '~> 1.4'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
end
