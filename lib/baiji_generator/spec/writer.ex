defmodule Baiji.Generator.Spec.Writer do
  @doc """
  Given a list of specs, write generated .ex files for each
  service to the path specified
  """
  alias Baiji.Generator.Spec

  def write(specs, write_path, template_file) when is_list(specs) do
    specs
    |> Enum.map(fn spec -> {spec, generate_service_file_contents(spec, template_file)} end)
    |> Enum.each(fn {spec, contents} -> write_service_file(write_path, spec, contents) end)
  end

  def generate_service_file_contents(%Spec{} = spec, template_file) do
    EEx.eval_file(template_file, [spec: spec, module: module_name(spec)], [trim: true])
  end

  def write_service_file(path, spec, contents) do
    Path.join(path, file_name(spec))
    |> File.write!(contents)
  end

  def then(out, fun), do: fun.(out)  

  @doc """
  Given a spec, generate an appropriate output file name
  """
  def file_name(%Spec{full_name: full_name, abbreviation: nil}) do
    full_name
    |> String.split([" ", "-", ".", "/"])
    |> Enum.filter(fn "Amazon" -> false; "AWS" -> false; _ -> true end)
    |> Enum.map(&String.downcase/1)
    |> Enum.join("_")
    |> Kernel.<>(".ex")
  end
  def file_name(%Spec{abbreviation: abbreviation}) do
    abbreviation
    |> String.split([" ", "-", ".", "/"])
    |> Enum.filter(fn "Amazon" -> false; "AWS" -> false; _ -> true end)
    |> Enum.map(&String.downcase/1)
    |> Enum.join("_")
    |> Kernel.<>(".ex")
  end

  @doc """
  Forms an output module name from a service
  """
  def module_name(%Spec{full_name: full_name, abbreviation: nil}) do
    full_name
    |> String.split([" ", "-", ".", "/"])
    |> Enum.filter(fn "Amazon" -> false; "AWS" -> false; _ -> true end)
    |> Enum.map(&String.capitalize/1)
    |> Enum.join
  end
  def module_name(%Spec{abbreviation: abbreviation}) do
    abbreviation
    |> String.split([" ", "-", ".", "/"])
    |> Enum.filter(fn "Amazon" -> false; "AWS" -> false; _ -> true end)
    |> Enum.join
  end
end