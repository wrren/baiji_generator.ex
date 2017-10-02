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
      service:        "<%= spec.service %>",
      endpoint:       "<%= action.uri %>",
      input:          input,
      options:        options,
      action:         "<%= action.name %>",
      <%= if spec.target_prefix != nil do %>
      target_prefix:  "<%= spec.target_prefix %>",
      <% end %>
      type:           :<%= spec.type %>,
      version:        "<%= spec.version %>",
      method:         :<%= action.method %>
    }
  end
  <% end %>
end