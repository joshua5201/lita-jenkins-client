# lita-jenkins-client

Lita jenkins handler that use the [jenkins\_api\_client gem](https://github.com/arangamani/jenkins_api_client)

RubyGems.org project website: [https://rubygems.org/gems/lita-jenkins-client](https://rubygems.org/gems/lita-jenkins-client)

## About
Integrate Lita and jenkins api. I've implement some commands which is usable now.

## Installation

Add lita-jenkins-client to your Lita instance's Gemfile:

``` ruby
gem "lita-jenkins-client" # Fetch from rubygems.org
gem "lita-jenkins-client", github: 'joshua5201/lita-jenkins-client' # Fetch from github
```

## Current Available Commands 

see `@lita help jenkins` for more info

```
@lita jenkins version 
@lita jenkins running?
@lita jenkins cli [cmd]
@lita jenkins version

@lita jenkins job build [job name] [param_key:param_value]
@lita jenkins job params [job name]
@lita jenkins job status [job name]
@lita jenkins job all
@lita jenkins job list [filter]
@lita jenkins job list_by_status [success/failure]
```

## Test
1. `cp spec/config.yml.example spec/config.yml` and edit your configurations.
2. Make sure you don't have project named after `test_with_param` and `test_without_param` 
3. `rspec`

## Contribute
1. feature: I only implement some of api from [jenkins\_api\_client gem](https://github.com/arangamani/jenkins_api_client), you can follow the structure and implement more commands.
2. bug: please report issues or just help me fix them. 
3. please provide RSpec tests

