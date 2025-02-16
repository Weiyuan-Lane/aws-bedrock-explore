require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module AwsBedrockExplore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Add lib directory to autoload and eager load paths
    config.autoload_paths += Dir[Rails.root.join('lib')]
    config.eager_load_paths += Dir[Rails.root.join('lib')]

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
