defmodule PhoenixHamlTest do
  use ExUnit.Case
  alias Phoenix.View

  defmodule MyApp.PageView do
    use Phoenix.View, root: "test/fixtures/templates"

    use Phoenix.HTML
  end

  test "render a haml template with layout" do
    html = View.render(MyApp.PageView, "new.html",
      message: "hi",
      layout: {MyApp.PageView, "application.html"}
    )
    assert html == {:safe, [[["" | "<html>\n  <body>\n    "], "" | "<h2>\n  New Template\n</h2>\n"] | "\n  </body>\n</html>\n"]}
  end

  test "render a haml template without layout" do
    html = View.render(MyApp.PageView, "new.html", [])
    assert html == {:safe, ["" | "<h2>\n  New Template\n</h2>\n"]}
  end
end
