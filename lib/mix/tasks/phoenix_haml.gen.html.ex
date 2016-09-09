defmodule Mix.Tasks.PhoenixHaml.Gen.Html do
  use Mix.Task

  @shortdoc "Generates controller, model, and views for an HTML based resource using HAML templates"

  @moduledoc """
  This file was adapted from the original Phoenix HTML generator found here:

  https://github.com/phoenixframework/phoenix/blob/v1.1/lib/mix/tasks/phoenix.gen.html.ex

  Generates a Phoenix resource with HAML templates.

      mix phoenix_haml.gen.html User users name:string age:integer

  The first argument is the module name followed by its plural name (used for resources and schema).

  The generated resource will contain:

    * a schema in web/models
    * a view in web/views
    * a controller in web/controllers
    * a migration file for the repository
    * default CRUD templates in web/templates
    * test files for generated model and controller

  The generated model can be skipped with `--no-model`.
  Read the documentation for `phoenix.gen.model` for more
  information on attributes and namespaced resources.
  """
  def run(args) do
    switches = [binary_id: :boolean, model: :boolean]

    {opts, parsed, _} = OptionParser.parse(args, switches: switches)
    [singular, plural | attrs] = validate_args!(parsed)

    default_opts = Application.get_env(:phoenix, :generators, [])
    opts = Keyword.merge(default_opts, opts)

    attrs   = Mix.Phoenix.attrs(attrs)
    binding = Mix.Phoenix.inflect(singular)
    path    = binding[:path]
    route   = String.split(path, "/") |> Enum.drop(-1) |> Kernel.++([plural]) |> Enum.join("/")
    binding = binding ++ [plural: plural, route: route, attrs: attrs,
                          binary_id: opts[:binary_id],
                          sample_id: sample_id(opts),
                          inputs: inputs(attrs), params: Mix.Phoenix.params(attrs),
                          template_singular: String.replace(binding[:singular], "_", " "),
                          template_plural: String.replace(plural, "_", " ")]

    Mix.Phoenix.check_module_name_availability!(binding[:module] <> "Controller")
    Mix.Phoenix.check_module_name_availability!(binding[:module] <> "View")

    Mix.Phoenix.copy_from paths(), "priv/templates/phoenix.gen.html", "", binding, [
      {:eex, "controller.ex",       "web/controllers/#{path}_controller.ex"},
      {:eex, "view.ex",             "web/views/#{path}_view.ex"},
      {:eex, "controller_test.exs", "test/controllers/#{path}_controller_test.exs"}
    ]

    generate_templates binding

    instructions = """

    Add the resource to your browser scope in web/router.ex:

        resources "/#{route}", #{binding[:scoped]}Controller
    """

    if opts[:model] != false do
      Mix.Task.run "phoenix.gen.model", ["--instructions", instructions|args]
    else
      Mix.shell.info instructions
    end
  end

  defp generate_templates(binding) do
    path = binding[:path]

    Mix.Phoenix.copy_from haml_paths(), "priv/templates/phoenix_haml.gen.html", "", binding, [
      {:eex, "edit.html.haml",       "web/templates/#{path}/edit.html.haml"},
      {:eex, "form.html.haml",       "web/templates/#{path}/form.html.haml"},
      {:eex, "index.html.haml",      "web/templates/#{path}/index.html.haml"},
      {:eex, "new.html.haml",        "web/templates/#{path}/new.html.haml"},
      {:eex, "show.html.haml",       "web/templates/#{path}/show.html.haml"},
    ]
  end

  defp sample_id(opts) do
    if Keyword.get(opts, :binary_id, false) do
      Keyword.get(opts, :sample_binary_id, "11111111-1111-1111-1111-111111111111")
    else
      -1
    end
  end

  defp validate_args!([_, plural | _] = args) do
    cond do
      String.contains?(plural, ":") ->
        raise_with_help
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  defp validate_args!(_) do
    raise_with_help
  end

  defp raise_with_help do
    Mix.raise """
    mix phoenix_haml.gen.html expects both singular and plural names
    of the generated resource followed by any number of attributes:
        mix phoenix_haml.gen.html User users name:string
    """
  end

  defp inputs(attrs) do
    Enum.map attrs, fn
      {_, {:array, _}} ->
        {nil, nil, nil}
      {_, {:references, _}} ->
        {nil, nil, nil}
      {key, :integer}    ->
        {label(key), ~s(= number_input f, #{inspect(key)}, class: "form-control"), error(key)}
      {key, :float}      ->
        {label(key), ~s(= number_input f, #{inspect(key)}, step: "any", class: "form-control"), error(key)}
      {key, :decimal}    ->
        {label(key), ~s(= number_input f, #{inspect(key)}, step: "any", class: "form-control"), error(key)}
      {key, :boolean}    ->
        {label(key), ~s(= checkbox f, #{inspect(key)}, class: "form-control"), error(key)}
      {key, :text}       ->
        {label(key), ~s(= textarea f, #{inspect(key)}, class: "form-control"), error(key)}
      {key, :date}       ->
        {label(key), ~s(= date_select f, #{inspect(key)}, class: "form-control"), error(key)}
      {key, :time}       ->
        {label(key), ~s(= time_select f, #{inspect(key)}, class: "form-control"), error(key)}
      {key, :datetime}   ->
        {label(key), ~s(= datetime_select f, #{inspect(key)}, class: "form-control"), error(key)}
      {key, _}           ->
        {label(key), ~s(= text_input f, #{inspect(key)}, class: "form-control"), error(key)}
    end
  end

  defp label(key) do
    ~s(= label f, #{inspect(key)}, class: "control-label")
  end

  defp error(field) do
    ~s(= error_tag f, #{inspect(field)})
  end

  defp paths do
    [".", :phoenix]
  end

  defp haml_paths do
    [".", :phoenix_haml]
  end
end
