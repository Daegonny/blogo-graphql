# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :blogo,
  ecto_repos: [Blogo.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :blogo, BlogoWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BlogoWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Blogo.PubSub,
  live_view: [signing_salt: "okCpzsxr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :blogo, query_depth_limit: 5
config :blogo, query_complexity_limit: 250

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
