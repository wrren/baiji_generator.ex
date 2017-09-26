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
      input:    input,
      options:  options,
      action:   "<%= action.name %>",
      type:     :<%= spec.type %>,
      method:   :<%= action.method %>
    }
  end
  <% end %>
end