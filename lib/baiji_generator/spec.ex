defmodule Baiji.Generator.Spec do
  defstruct spec_file:    nil,
            doc_file:     nil,
            docs:         nil,
            service:      nil,
            version:      nil,
            type:         :unknown,
            module_name:  nil,
            actions:      []
end