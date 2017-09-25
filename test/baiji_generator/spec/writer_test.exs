defmodule Baiji.Generator.Spec.WriterTest do
  use ExUnit.Case, async: true

  alias Baiji.Generator.Spec
  alias Baiji.Generator.Spec.Writer

  test "correctly generates file name" do
    assert Writer.file_name(%Spec{service: "Auto Scaling"}) == "auto_scaling.ex"
    assert Writer.file_name(%Spec{service: "EC2"})          == "ec2.ex"
    assert Writer.file_name(%Spec{service: "AWS Glue"})     == "aws_glue.ex"
  end
end