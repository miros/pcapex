# Pcapex

![Build status](https://github.com/miros/pcapex/actions/workflows/ci.yml/badge.svg?branch=master)

Simple library in pure Elixir for encoding and decoding pcap file data

## Usage

Add `pcapex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:pcapex, "~> 0.0.6"}]
end
```

```elixir
alias Pcapex.Dump
alias Pcapex.Packet

packet = Packet.from_hex(packet_data, timestamp_usec: DateTime.utc_now() |> DateTime.to_unix(:microsecond))
binary_dump_data = Dump.new([packet]) |> Dump.to_binary()

%Dump{} = Dump.from_binary(binary_dump_data) 
```
