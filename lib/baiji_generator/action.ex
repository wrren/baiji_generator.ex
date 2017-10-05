defmodule Baiji.Generator.Action do
  defstruct name:           nil,
            function_name:  nil,
            method:         :unknown,
            uri:            nil,
            docs:           nil,
            input_shape:    nil,
            output_shape:   nil,
            output_wrapper: nil
end