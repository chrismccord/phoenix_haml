defmodule PhoenixHaml.Engine do
  @behaviour Phoenix.Template.Engine

  @doc """
  Precompiles the String file_path into a function defintion, using Calliope engine
  """
  def compile(path, _name) do
    path
    |> read!
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, file: path, line: 1)
  end

  defp read!(file_path) do
    try do
      file_path |> File.read! |> Calliope.Render.precompile
    rescue
      exception ->
        case exception do
          %CalliopeException{message: message} ->
            reraise %CalliopeException{message: "#{file_path}: " <> message}, System.stacktrace
          _ ->
            reraise exception, System.stacktrace
        end
    end
  end
end
