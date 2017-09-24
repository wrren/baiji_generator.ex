defmodule Baiji.Generator.Spec.FinderTest do
  use ExUnit.Case, async: true

  alias Baiji.Generator.Spec.Finder

  test "correctly generates module names" do
    assert Finder.module_name("ec2")          == "EC2"
    assert Finder.module_name("AWS codegen")  == "AWSCodegen"
    assert Finder.module_name("application-autoscaling") == "ApplicationAutoscaling"
  end

  test "correctly finds latest version directory" do
    assert Finder.get_latest_version!([
      "2017-01-01",
      "2016-06-10",
      "latest"
    ]) == "2017-01-01"
  end
end