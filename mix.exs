defmodule Flasked.Mixfile do
  use Mix.Project

  def project do
    [app: :flasked,
     version: "0.1.0",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application, do: [mod: {Flasked, []}]

  defp deps do
    [
      {:credo, "~> 0.2", only: [:dev, :test]}
    ]
  end
end
