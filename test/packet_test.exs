defmodule Pcapex.PacketTest do
  use ExUnit.Case

  alias Pcapex.Packet

  describe "#new" do
    test "creates packet with sec timestamp" do
      assert Packet.new(data: "20AA966B40", timestamp_sec: 12345.123) == %Packet{
               data: "20AA966B40",
               original_size: 10,
               timestamp_usec: 12345_123_000
             }
    end

    test "creates packet with usec timestamp" do
      assert Packet.new(data: "20AA966B40", timestamp_usec: 12345) == %Packet{
               data: "20AA966B40",
               original_size: 10,
               timestamp_usec: 12345
             }
    end
  end

  describe "#datetime" do
    test "returns packet timestamp as DateTime" do
      time = DateTime.utc_now()
      assert Packet.new(_data = "", DateTime.to_unix(time, :microsecond)) |> Packet.datetime() == time
    end
  end

  describe "#to_hex" do
    test "returns packet data as hex string" do
      packet = Packet.from_hex("20AA966B40", timestamp_usec: DateTime.utc_now() |> DateTime.to_unix(:microsecond))
      assert Packet.to_hex(packet) == "20AA966B40"
    end
  end

  describe "#timestamp_sec" do
    test "returns packet timestamp in seconds" do
      assert Packet.new(_data = "", 12345_000_000) |> Packet.timestamp_sec() == 12345.000000
    end
  end
end
