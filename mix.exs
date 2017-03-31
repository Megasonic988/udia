defmodule Udia.Mixfile do
  use Mix.Project

  def project do
    [app: :udia,
     version: "0.2.0",
     elixir: "~> 1.4.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     description: description(),
     package: package(),
     test_coverage: [tool: ExCoveralls]]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Udia.Application, []},
     extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0-rc"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:excoveralls, "~> 0.6", only: :test},
     {:credo, "~> 0.7", only: [:dev, :test]}]
  end

  defp description do
    """
    A web application in pursuit of solving meaning, validating universal basic income, and happiness.
    """
  end

  defp package do
    [name: :udia,
     files: ["lib", "priv", "mix.exs", "README*", "LICENSE*", "config", "test", "logo*", "elixir_buildpack.config",
            "assets/css", "assets/js", "assets/static", "assets/vendor", "assets/brunch-config.js", "assets/package.json",   
            "phoenix_static_buildpack.config", "Procfile", ".gitignore", ".travis.yml"],
     maintainers: ["Udia Software Incorporated", "Alexander Wong"],
     licenses: ["Common Public Attribution License Version 1.0 (CPAL)"],
     links: %{"GitHub" => "https://github.com/udia-software/udia",
              "Site" => "https://a.udia.ca"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
