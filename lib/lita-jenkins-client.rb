require "lita"
require "jenkins_api_client"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/jenkins_client"
require "lita/handlers/jenkins_client/base_action"

Lita::Handlers::JenkinsClient.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
