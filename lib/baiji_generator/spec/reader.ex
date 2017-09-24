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
  def read_spec!(%{"metadata" => %{"serviceFullName" => full_name, "xmlNamespace" => _}} = contents, spec) do
    %{spec | service: full_name, type: :xml, actions: read_actions!(contents)}
  end
  def read_spec!(%{"metadata" => %{"serviceFullName" => full_name, "jsonVersion" => _}} = contents, spec) do
    %{spec | service: full_name, type: :json, actions: read_actions!(contents)}
  end
  def read_spec!(%{"metadata" => %{"serviceFullName" => full_name, "protocol" => "rest-json"}} = contents, spec) do
    %{spec | service: full_name, type: :rest_json, actions: read_actions!(contents)}
  end
  def read_spec!(%{"metadata" => %{"serviceFullName" => full_name, "protocol" => "rest-xml"}} = contents, spec) do
    %{spec | service: full_name, type: :rest_xml, actions: read_actions!(contents)}
  end

  @doc """
  Decode actions from the contents of an API spec file
  """
  def read_actions!(%{"operations" => operations}) do
    operations
    |> Map.to_list
    |> Enum.map(fn action -> read_action!(action) end)
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
      docs: docs, 
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
        %{action | docs: docs}        
    end
  end
end