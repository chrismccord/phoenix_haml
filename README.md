# Phoenix Template Engine for Haml

> Powered by [Calliope](https://github.com/nurugger07/calliope)


## Usage

  1. Add `{:phoenix_haml, "~> 0.1.1"}` to your deps in `mix.exs`.
     If you generated your app from the Phoenix master branch,
     add phoenix_haml's master branch to your deps instead.
     `{:phoenix_haml, github: "chrismccord/phoenix_haml"}`
  2. Add the following to your Phoenix `config/config.exs`

     ```elixir
    config :phoenix, :template_engines,
      haml: PhoenixHaml.Engine
     ```
  3. Use the `.html.haml` extensions for your templates

## Optional

Add haml extension to Phoenix live reload in `config/dev.exs`

```elixir
  config :hello_phoenix, HelloPhoenix.Endpoint,
    live_reload: [
      patterns: [
        ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
        ~r{web/views/.*(ex)$},
        ~r{web/templates/.*(eex|haml)$}
      ]
    ]

```
