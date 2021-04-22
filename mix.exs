defmodule Pcapex.MixProject do
  use Mix.Project

  def project do
    [
      app: :pcapex,
      version: "0.0.2",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      dialyzer: dialyzer()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [{:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false}]
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
end
