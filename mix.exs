defmodule ExCors.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :ex_cors,
      version:         "0.2.0",
      elixir:          "~> 1.5",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description:     description(),
      package:         package(),
      deps:            deps(),
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18", runtime: false},
      {:plug, "~> 1.4"},
    ]
  end

  defp description do
    """
      An Elixir Plug-based CORS middleware for Phoenix Framework.
    """
  end

  defp package do
    [
     name:        :ex_cors,
     files:       ["lib", "config", "mix.exs", "README.md"],
     maintainers: ["Kamil Lelonek"],
     licenses:    ["Apache 2.0"],
     links: %{
       "GitHub" => "https://github.com/KamilLelonek/ex_cors",
       "Docs"   => "https://hexdocs.pm/ex_cors/",
     },
    ]
  end
end
