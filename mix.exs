defmodule Pcapex.MixProject do
  use Mix.Project

  def project do
    [
      app: :pcapex,
      version: "0.0.6",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      dialyzer: dialyzer(),
      description: "Simple library in pure Elixir for encoding and decoding pcap file data",
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      preferred_cli_env: [
        cover: :test,
        "cover.detail": :test,
        "cover.html": :test,
        "cover.filter": :test,
        "cover.lint": :test,
        dialyzer: :test
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      name: :pcapex,
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Miroslav Malkin"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/miros/pcapex"
      }
    ]
  end

  def dialyzer() do
    [
      flags: [:unmatched_returns, :error_handling, :race_conditions, :unknown]
    ]
  end

  defp aliases do
    [
      test: ["test --no-start"],
      cover: ["coveralls --sort cov:desc"],
      "cover.lint": [
        "coveralls.lint --required-project-coverage=0.9 --missed-lines-threshold=2 --required-file-coverage=0.9"
      ],
      "cover.html": ["coveralls.html"],
      "cover.detail": ["coveralls.detail --filter"]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.13", only: :test},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls_linter, "~> 0.2.0", only: :test}
    ]
  end
end
