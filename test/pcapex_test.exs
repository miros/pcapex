defmodule PcapexTest do
  use ExUnit.Case
  doctest Pcapex

  test "greets the world" do
    assert Pcapex.hello() == :world
  end
end
