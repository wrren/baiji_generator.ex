defmodule Mix.Tasks.Generate do
  use Mix.Task

  alias Baiji.Generator

  @shortdoc "Generate AWS service code"
  def run([input, template, output]) do
    %Generator{ spec_directory:     input,
                write_directory:    output,
                template_directory: template}
    |> Generator.read_specs
    |> Generator.write_specs
  end
end