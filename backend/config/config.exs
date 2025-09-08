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

# Database config
config :backend, Backend.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASS"),
  hostname: System.get_env("DB_HOST") || "db",
  database: System.get_env("DB_NAME"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  after_connect: fn _conn ->
    :timer.sleep(2000)
  end

config :backend,
  ecto_repos: [Backend.Repo]

# API tokens
config :backend, :google_api_key,
  token: System.get_env("GEMINI_TOKEN")

# Phoenix endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  http: [ip: {0, 0, 0, 0}, port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  server: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  adapter: Phoenix.Endpoint.Cowboy2Adapter

# Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# JSON library
config :phoenix, :json_library, Jason
