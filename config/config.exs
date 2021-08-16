# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :lopes_ui, LopesUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bBEGmYN3L0RXH4RcT/uKIf7zq1Z2uGVlzgiWdctSHt9viHEg1sDdUlMhhBZ/F473",
  render_errors: [view: LopesUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LopesUi.PubSub,
  live_view: [signing_salt: "ypxAFyY1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix,
  json_library: Jason,
  template_engines: [leex: Phoenix.LiveView.Engine]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
