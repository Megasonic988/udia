use Mix.Config

config :udia,
  ecto_repos: [Udia.Repo]

config :udia, Udia.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hYywfBjO0UWwRXFyPCimrtCBLqCL5pbuvCcq31O2kE9tamarHP0avawxKANPtG62",
  render_errors: [view: Udia.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Udia.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verivy_module: Guardian.JWT,
  issuer: "Udia",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Udia.GuardianSerializer

import_config "#{Mix.env}.exs"
