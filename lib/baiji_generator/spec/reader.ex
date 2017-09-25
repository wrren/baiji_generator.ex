defmodule Baiji.Generator.Spec.Reader do
  alias Baiji.Generator.{
    Spec,
    Action
  }

  @doc """
  Given a list of Spec structs populated by the Finder module,
  read the spec files themselves and populate the remaining
  struct fields
  """
  def read!(specs) when is_list(specs) do
    specs
    |> Enum.map(fn spec -> read_spec_file!(spec) end)
    |> Enum.map(fn spec -> read_doc_file!(spec) end)
  end

  @doc """
  Read the contents of a spec file and generate list of actions
  """
  def read_spec_file!(%Spec{spec_file: file} = spec) when is_binary(file) do
    File.read!(file)
    |> Poison.decode!
    |> read_spec!(spec)
  end

  @doc """
  Read the decoded XML contents of an API spec and populate the fields of the given spec struct
  """
  def read_spec!(%{"metadata" => %{"xmlNamespace" => _}} = contents, spec) do
    %{spec | type: :xml, actions: read_actions!(contents)}
  end
  def read_spec!(%{"metadata" => %{"jsonVersion" => _}} = contents, spec) do
    %{spec | type: :json, actions: read_actions!(contents)}
  end
  def read_spec!(%{"metadata" => %{"protocol" => "rest-json"}} = contents, spec) do
    %{spec | type: :rest_json, actions: read_actions!(contents)}
  end
  def read_spec!(%{"metadata" => %{"protocol" => "rest-xml"}} = contents, spec) do
    %{spec | type: :rest_xml, actions: read_actions!(contents)}
  end

  @doc """
  Decode actions from the contents of an API spec file
  """
  def read_actions!(%{"operations" => operations}) do
    operations
    |> Map.to_list
    |> Enum.map(fn action -> read_action!(action) end)
    |> Enum.map(fn action -> %{action | function_name: function_name(action.name)} end)
  end

  @doc """
  Read metadata about an AWS API operation into an Action struct
  """
  def read_action!({name, %{"http" => %{"method" => "POST", "requestUri" => uri}}}) do
    %Action{name: name, method: :post, uri: uri}
  end
  def read_action!({name, %{"http" => %{"method" => "PATCH", "requestUri" => uri}}}) do
    %Action{name: name, method: :patch, uri: uri}
  end
  def read_action!({name, %{"http" => %{"method" => "PUT", "requestUri" => uri}}}) do
    %Action{name: name, method: :put, uri: uri}
  end
  def read_action!({name, %{"http" => %{"method" => "GET", "requestUri" => uri}}}) do
    %Action{name: name, method: :get, uri: uri}
  end
  def read_action!({name, %{"http" => %{"method" => "DELETE", "requestUri" => uri}}}) do
    %Action{name: name, method: :delete, uri: uri}
  end
  def read_action!({name, %{"http" => %{"method" => "HEAD", "requestUri" => uri}}}) do
    %Action{name: name, method: :head, uri: uri}
  end

  @doc """
  Read and decode the contents of a docs-2 file and attach documentation to each action in 
  the given spec and to the spec itself
  """
  def read_doc_file!(%Spec{doc_file: file} = spec) do
    file
    |> File.read!
    |> Poison.decode!
    |> read_docs(spec)
  end

  @doc """
  Read decoded documentation XML and populate fields in the given spec struct
  """
  def read_docs(%{"operations" => operations, "service" => docs}, %Spec{actions: actions} = spec) do
    %{spec | 
      docs: Baiji.Generator.Docs.format(docs), 
      actions: Enum.map(actions, fn action -> read_action_docs(action, operations) end)
    }
  end

  @doc """
  Given an operations map from a docs-2 file and an action, attempt to populate the action's docs field
  """
  def read_action_docs(%Action{name: name} = action, operations) do
    case Map.get(operations, name) do
      nil ->
        %{action | docs: "No Documentation Availabale"}
      docs ->
        %{action | docs: Baiji.Generator.Docs.format(docs)}        
    end
  end

  def then(out, fun), do: fun.(out)

  @doc """
  Forms an output module name from a service
  """
  def module_name(service) do
    service
    |> String.split([" ", "-"])
    |> Enum.map(fn component ->
      case String.length(component) do
        len when len <= 3 ->
          String.upcase(component)
        _ ->
          String.capitalize(component)
      end
    end)
    |> Enum.join
  end

  @doc """
  Generate an appropriate function name for the given Action
  """
  def function_name(name) do
    name
    |> String.graphemes
    |> Enum.reduce({[], []}, fn(chr, {out, current}) ->
      if chr >= "A" and chr <= "Z" do
        {[Enum.join(:lists.reverse(current)) | out], [chr]}
      else
        {out, [chr | current]}
      end
    end)
    |> then(fn {out, current} -> :lists.reverse([Enum.join(:lists.reverse(current)) | out]) end)
    |> Enum.filter(fn string -> String.length(string) > 0 end)
    |> Enum.map(fn string -> String.downcase(string) end)
    |> Enum.join("_")
  end
end