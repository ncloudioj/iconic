defmodule Iconic.Mixfile do
  use Mix.Project

  def project do
    [
      app: :iconic,
      version: "0.1.1",
      elixir: "~> 1.5",
      build_embeded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      name: "Iconic",
      deps: deps(),
      source_url: "https://github.com/ncloudioj/iconic"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:httpoison],
      mod: {Iconic, []},
      env: [http_client: HTTPoison]
    ]
  end

  defp description do
    ~s(
      An simple icon discovery application that supports icon, apple-touch-icon, applie-touch-icon-precomposed, fluid-icon, and mask-icon.
    )
  end

  defp package do
    [
      maintainers: ["Nan Jiang"],
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/ncloudioj/iconic"}
    ]
  end

  defp deps do
    [
      {:floki, "~> 0.18.0"},
      {:httpoison, "0.13.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:earmark, "~> 1.2.3", only: [:dev]},
      {:ex_doc, "~> 0.18.1", only: [:dev]}
    ]
  end
end
