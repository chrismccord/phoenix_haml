defmodule Mix.Tasks.PhoenixHaml.Gen.Layout do
  use Mix.Task

  @shortdoc "Generates a HAML layout template"

  @moduledoc """
  Generates the `web/templates/layout/app.html.haml` template. 

  The `app.html.eex` template is renamed to `app.html.eex.save` 
  if it exists.

      mix phoenix_haml.gen.layout

  """

  def run(_args) do
    binding = Mix.Project.config 
    |> Keyword.fetch!(:app)
    |> Atom.to_string
    |> Mix.Phoenix.inflect

    Mix.Phoenix.copy_from haml_paths(), "priv/templates/phoenix_haml.gen.layout", "", binding, [
      {:eex, "app.html.haml", "web/templates/layout/app.html.haml"},
    ]

    instructions = """

    The web/templates/layout/app.html.eex template has been
    renamed to web/templates/layout/app.html.eex.save
    """

    path = "web/templates/layout/app.html.eex"
    
    if File.exists? path do
      File.rename path, path <> ".save"
      Mix.shell.info instructions
    end
  end

  defp haml_paths do
    [".", :phoenix_haml]
  end
end
