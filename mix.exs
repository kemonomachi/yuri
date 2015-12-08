defmodule YURI.Mixfile do
  use Mix.Project

  def project do
    [app: :yuri,
     version: "0.7.0",
     elixir: "~> 1.0",
     deps: deps,
     name: "YURI",
     source_url: "https://github.com/kemonomachi/yuri",
     docs: [extras: ["README.md": [path: "README.md", title: "README"]]]]
  end

  defp deps do
    [{:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.11", only: :dev}]
  end
end

