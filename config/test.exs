import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pingme, Pingme.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pingme_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pingme, PingmeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lB9XMuzO/hnaX0oXqApkr1fHo7y19MozZVLU4jaoRLuuMns7E+PoD2hC7f4I5547",
  server: false

# In test we don't send emails.
config :pingme, Pingme.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :libcluster, :topologies,
  test: [
    strategy: Cluster.Strategy.Epmd,
    config: [hosts: []]
  ]
