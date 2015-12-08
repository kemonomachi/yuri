defmodule YURI.Mixfile do
  use Mix.Project

  def project do
    [app: :yuri,
     description: "Simple struct for representing URIs.",
     version: "1.0.0",
     elixir: "~> 1.0",
     deps: deps,
     package: package,
     name: "YURI",
     source_url: "https://github.com/kemonomachi/yuri",
     docs: [extras: ["README.md": [path: "README", title: "README"]],
            main: "README"]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end

  defp package do
    [maintainers: ["Ookami"],
     licenses: ["WTFPL"],
     links: %{"GitHub" => "https://github.com/kemonomachi/yuri"}]
  end
end

