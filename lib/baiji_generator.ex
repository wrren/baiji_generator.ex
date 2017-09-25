defmodule Baiji.Generator do
  alias Baiji.Generator
  
  defstruct spec_directory: nil,
            write_directory: nil,
            template_directory: nil,
            specs: []

  def main(args \\ []) do
    args
    |> parse_args
    |> read_specs
    |> write_specs
  end

  def parse_args(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [
      spec_directory:     :string,
      write_directory:    :string,
      template_directory: :string
    ])
    %Generator{ spec_directory:     Keyword.get(opts, :spec_directory),
                write_directory:    Keyword.get(opts, :write_directory),
                template_directory: Keyword.get(opts, :template_directory)}
  end

  def read_specs(%Generator{spec_directory: nil}) do
    raise Generator.Error, message: "No spec directory specified"
  end
  def read_specs(%Generator{spec_directory: dir} = struct) do
    if not File.exists?(dir) do
      raise Generator.Error, message: "The specified API spec directory does not exist"
    end

    specs = dir
    |> Generator.Spec.Finder.find!
    |> Generator.Spec.Reader.read!

    %{struct | specs: specs}
  end

  def write_specs(%Generator{write_directory: nil}) do
    raise Generator.Error, message: "No write directory specified"
  end

  def write_specs(%Generator{template_directory: nil}) do
    raise Generator.Error, message: "No template directory specified"
  end

  def write_specs(%Generator{write_directory: write, template_directory: template, specs: specs}) do
    if not File.exists?(write) do
      raise Generator.Error, message: "The specified output directory does not exist"
    end

    if not File.exists?(template) do
      raise Generator.Error, message: "The specified template directory does not exist"
    end

    Generator.Spec.Writer.write(specs, write, template)
  end
end