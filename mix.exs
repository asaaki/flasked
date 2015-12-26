defmodule Flasked.Mixfile do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :flasked,
      name: "flasked",
      version: @version,
      elixir: "~> 1.1",
      description: description,
      source_url: "https://github.com/asaaki/flasked",
      homepage_url: "http://hexdocs.pm/flasked",
      package: package,
      docs: &docs/0,
      deps: deps
    ]
  end

  def application, do: [mod: {Flasked, []}]

  defp description do
    """
    Flasked injects application environment configuration at runtime based on given ENV variables and a mapping.
    This is pretty useful for applications following the 12factor app principle or which are deployed in
    containerization infrastructures like Docker.
    """
  end

  defp package do
    [
      files: package_files,
      maintainers: ["Christoph Grabo"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/asaaki/flasked",
        "Docs" => "http://hexdocs.pm/flasked"
      }
    ]
  end

  defp package_files do
    ~w(lib priv config mix.exs README.md LICENSE)
  end

  defp docs do
    [
      extras: ["README.md"], main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/asaaki/flasked"
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.2", only: [:dev, :test]},
      {:ex_doc, "~> 0.11", only: [:docs]},
      {:earmark, "~> 0.1", only: [:docs]},
    ]
  end
end
