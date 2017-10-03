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
      service:          "<%= spec.service %>",
      endpoint:         "<%= action.uri %>",
      input:            input,
      options:          options,
      action:           "<%= action.name %>",
      <%= if spec.target_prefix != nil do %>
      target_prefix:    "<%= spec.target_prefix %>",
      <% end %>
      endpoint_prefix:  "<%= spec.endpoint_prefix %>",
      type:             :<%= spec.type %>,
      version:          "<%= spec.version %>",
      method:           :<%= action.method %>,
      input_shape:      "<%= action.input_shape %>",
      output_shape:     "<%= action.output_shape %>",
      shapes:           &__MODULE__.__shapes__/0
    }
  end

  <% end %>

  @doc """
  Returns a map containing the input/output shapes for this endpoint
  """
  def __shapes__ do
    <%= inspect(spec.shapes, limit: :infinity) %>
  end
end