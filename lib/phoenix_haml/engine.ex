defmodule PhoenixHaml.Engine do
  @behaviour Phoenix.Template.Engine

  @doc """
  Precompiles the String file_path into a function defintion, using Calliope engine
  """
  def compile(path, name) do
    path
    |> read!
    |> EEx.compile_string(engine: engine_for(name), file: path, line: 1)
  end

  defp read!(file_path) do
    file_path |> File.read! |> Calliope.Render.precompile
  end

  defp engine_for(name) do
    case Phoenix.Template.format_encoder(name) do
      Phoenix.Template.HTML ->
        unless Code.ensure_loaded?(Phoenix.HTML.Engine) do
          raise "Could not load Phoenix.HTML.Engine to use with .html.haml templates. " <>
                "You can configure your own format encoder for HTML but we recommend " <>
                "adding phoenix_html as a dependency as it provides XSS protection."
        end
        Phoenix.HTML.Engine
      _ ->
        EEx.SmartEngine
    end
  end
end

