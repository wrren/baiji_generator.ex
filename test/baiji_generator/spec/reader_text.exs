defmodule Baiji.Generator.Spec.ReaderTest do
  use ExUnit.Case, async: true

  alias Baiji.Generator.Spec.Reader

  test "function name composition" do
    assert Reader.function_name("DescribeInstances")  == "describe_instances"
    assert Reader.function_name("Test")               == "test"
    assert Reader.function_name("BatchCreatePartitionRequest")  == "batch_create_partition_request"
  end
end