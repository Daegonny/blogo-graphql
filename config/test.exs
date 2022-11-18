import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :blogo, Blogo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "blogo_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blogo, BlogoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ItrzvUBoI3BAciq2dU+5C8hHmIYKQ5+a7GKzMQE/nTiOe6eB/DwbkJ2E52c2OmpS",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :blogo, query_complexity_limit: 25

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
