# Baiji.Generator

Generates AWS Service code for [Baiji](https://github.com/wrren/baiji.ex). Reads API spec JSON files from the aws-sdk-go project in order to generate corresponding modules and functions.

## Usage

```elixir
mix generate <api directory> <template file> <write directory>
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `baiji_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:baiji_generator, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/baiji_generator](https://hexdocs.pm/baiji_generator).

