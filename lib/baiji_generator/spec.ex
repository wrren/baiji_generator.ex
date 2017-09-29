defmodule Baiji.Generator.Spec do
  defstruct spec_file:      nil,
            doc_file:       nil,
            docs:           nil,
            service:        nil,
            full_name:      nil,
            abbreviation:   nil,
            target_prefix:  nil,
            version:        nil,
            type:           :unknown,
            actions:        []
end