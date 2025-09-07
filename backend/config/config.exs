import Config

# Load .env into System environment
".env"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.each(fn line ->
  case String.split(line, "=", parts: 2) do
    [key, value] -> System.put_env(key, value)
    _ -> :ok
  end
end)

# Database config (instead of dev.exs/prod.exs/test.exs)
# config :backend, Backend.Repo,
#   username: "postgres",
#   password: "postgres",
#   hostname: "localhost",
#   database: "backend_dev",
#   show_sensitive_data_on_connection_error: true,
#   pool_size: 10,
#   http: [ip: {0, 0, 0, 0}, port: 4000],
#   server: true

# Database config
config :backend, Backend.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  hostname: System.get_env("DB_HOST"),
  database: System.get_env("DB_NAME"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Ecto repos
config :backend,
  ecto_repos: [Backend.Repo]

config :backend, :huggingface,
  token: System.get_env("HUGGINGFACE_TOKEN")

# Phoenix endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  http: [ip: {0, 0, 0, 0}, port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  server: true, # important to start Cowboy server
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  adapter: Phoenix.Endpoint.Cowboy2Adapter

# Logger configuration
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing
config :phoenix, :json_library, Jason
