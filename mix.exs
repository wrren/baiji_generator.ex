defmodule Baiji.Generator.Mixfile do
  use Mix.Project

  def project do
    [
      app: :baiji_generator,
      version: "0.1.0",
      elixir: "~> 1.5",
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def escript do
    [main_module: Baiji.Generator]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1.0"}
    ]
  end
end
