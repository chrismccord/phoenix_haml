defmodule PhoenixHaml.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_haml,
      version: "0.2.0",
      elixir: "~> 1.0.1 or ~> 1.1",
      deps: deps,
      package: [
        contributors: ["Chris McCord"],
        licenses: ["MIT"],
        links: %{github: "https://github.com/chrismccord/phoenix_haml"}
      ],
      description: """
      Phoenix Template Engine for Haml
      """
    ]
  end

  def application do
    [applications: [:phoenix, :calliope]]
  end

  defp deps do
    [
      {:phoenix, "~> 1.0.0"},
      {:phoenix_html, "~> 2.1"},
      {:calliope, "~> 0.3.0"}
    ]
  end
end
