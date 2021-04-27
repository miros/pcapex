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

  @type params :: [
          data: binary,
          timestamp_usec: pos_integer,
          timestamp_sec: float,
          original_size: pos_integer
        ]

  @usecs_in_sec 1000 * 1000

  @spec new(params) :: t
  def new(params) when is_list(params) do
    data = Keyword.fetch!(params, :data)

    timestamp_usec =
      if timestamp_sec = Keyword.get(params, :timestamp_sec) do
        trunc(timestamp_sec * @usecs_in_sec)
      else
        Keyword.fetch!(params, :timestamp_usec)
      end

    original_size = Keyword.get(params, :original_size, nil)

    new(data, timestamp_usec, original_size)
  end

  @spec from_hex(String.t(), params) :: t
  def from_hex(hex_data, params) do
    data = Base.decode16!(hex_data, case: :mixed)
    new(Keyword.merge(params, data: data))
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
