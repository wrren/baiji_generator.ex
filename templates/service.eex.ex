defmodule Baiji.<%= module %> do
  @moduledoc """
<%= spec.docs %>

  """

  <%= for action <- spec.actions do %>
  @doc """
<%= action.docs %>

  """
  def <%= action.function_name %>(input \\ %{}, options \\ []) do
    %Baiji.Operation{
      path:             "<%= action.uri %>",
      input:            input,
      options:          options,
      action:           "<%= action.name %>",
      method:           :<%= action.method %>,
      input_shape:      "<%= action.input_shape %>",
      output_shape:     "<%= action.output_shape %>",
      <%= if action.output_wrapper != nil do %>
      output_wrapper:   "<%= action.output_wrapper %>",
      <% end %>      
      endpoint:         __spec__()
    }
  end

  <% end %>

  @doc """
  Outputs values common to all actions
  """
  def __spec__ do
    %Baiji.Endpoint{
      service:          "<%= spec.service %>",
<%= if spec.target_prefix != nil do %>
      target_prefix:    "<%= spec.target_prefix %>",
<% end %>
      endpoint_prefix:  "<%= spec.endpoint_prefix %>",
      type:             :<%= spec.type %>,
      version:          "<%= spec.version %>",
      shapes:           __shapes__()
    }
  end

  @doc """
  Returns a map containing the input/output shapes for this endpoint
  """
  def __shapes__ do
    <%= "\t\t" <> inspect(spec.shapes, limit: :infinity) %>

  end
end