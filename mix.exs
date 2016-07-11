defmodule PhoenixHaml.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_haml,
      version: "0.2.2",
      elixir: "~> 1.0.1 or ~> 1.1",
      deps: deps,
      package: [
        contributors: ["Chris McCord", "Stephen Pallen"],
        maintainers: ["Chris McCord", "Stephen Pallen"],
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
      {:phoenix, "~> 1.1"},
      {:phoenix_html, "~> 2.3"},
      {:calliope, "~> 0.4.1"}
    ]
  end
end
