defmodule Baiji.Generator.Spec.Writer do
  @doc """
  Given a list of specs, write generated .ex files for each
  service to the path specified
  """
  alias Baiji.Generator.Spec

  def write(specs, write_path, template_file) when is_list(specs) do
    specs
    |> Enum.map(fn spec -> {spec, generate_service_file(spec, template_file)} end)
    |> Enum.each(fn {spec, contents} -> write_service_file(write_path, spec, contents) end)
  end

  def generate_service_file(%Spec{} = spec, template_file) do
    EEx.eval_file(template_file, [spec: spec])
  end

  def write_service_file(path, spec, contents) do
    Path.join(path, file_name(spec))
    |> File.write!(contents)
  end

  def then(out, fun), do: fun.(out)  

  @doc """
  Given an AWS service name, generate an appropriate output file name
  """
  def file_name(%Spec{service: service}) do
    service
    |> String.split(" ")
    |> Enum.filter(fn component -> String.length(component) > 0 end)
    |> Enum.filter(fn "Amazon" -> false; "AWS" -> false; _ -> true end)
    |> Enum.map(fn component -> String.downcase(component) end)
    |> Enum.join("_")
    |> Kernel.<>(".ex")
  end
end