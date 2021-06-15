# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cas,
  ecto_repos: [Cas.Repo]

# Configures the endpoint
config :cas, CasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9nVJziIqHOCRPWb8sF41RhQ/ccxGwgOsvRZurHqhtYUlWjvWoDUPlrVpfvnhXAH0",
  render_errors: [view: CasWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Cas.PubSub,
  live_view: [signing_salt: "KRKqO6xo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
