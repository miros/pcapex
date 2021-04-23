defmodule Pcapex.Packet do
  defstruct timestamp_usec: nil,
            original_size: 0,
            data: <<"">>

  @type t :: %__MODULE__{
          timestamp_usec: pos_integer,
          original_size: pos_integer,
          data: binary()
        }

  @spec new(binary, pos_integer, pos_integer | nil) :: t
  def new(data, timestamp_usec, original_size \\ nil) do
    %__MODULE__{
      data: data,
      timestamp_usec: timestamp_usec,
      original_size: original_size || byte_size(data)
    }
  end

  @spec from_hex(String.t(), pos_integer, pos_integer | nil) :: t
  def from_hex(hex_data, timestamp_usec, original_size \\ nil) do
    hex_data |> Base.decode16!(case: :mixed) |> new(timestamp_usec, original_size)
  end

  @spec timestamp_sec(t) :: float()
  def timestamp_sec(packet) do
    packet.timestamp_usec / 1000 / 1000
  end

  @spec to_hex(t) :: String.t()
  def to_hex(packet) do
    Base.encode16(packet.data)
  end

  @spec datetime(t) :: DateTime.t()
  def datetime(packet) do
    DateTime.from_unix!(packet.timestamp_usec, :microsecond)
  end
end
