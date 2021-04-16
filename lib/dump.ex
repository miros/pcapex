defmodule Pcapex.Dump do
  alias Pcapex.Packet

  @linux_sll_network_type 113
  @default_netwotk_type @linux_sll_network_type

  @magic_number 0xA1B2C3D4
  @version_major 2
  @version_minor 4
  @max_packet_size 65535

  defstruct network_type: @default_netwotk_type,
            packets: []

  @type t :: %__MODULE__{
          network_type: pos_integer,
          packets: list(Packet.t())
        }

  @spec new(list(Packet.t()), pos_integer) :: t
  def new(packets, network_type \\ @default_netwotk_type) do
    %__MODULE__{
      packets: packets,
      network_type: network_type
    }
  end

  @spec to_binary(t) :: binary()
  def to_binary(dump) do
    dump_header(dump.network_type) <> Enum.map_join(dump.packets, &record/1)
  end

  # TODO implement better error handling

  @spec from_binary(binary) :: t()
  def from_binary(data) do
    <<
      @magic_number::unsigned-32,
      @version_major::unsigned-16,
      @version_minor::unsigned-16,
      _thiszone::signed-32,
      _sigfigs::unsigned-32,
      _max_packet_size::unsigned-32,
      network_type::unsigned-32,
      records_data::binary
    >> = data

    records_data |> parse_records() |> new(network_type)
  end

  # guint32 magic_number;   /* magic number; always 0xa1b2c3d4 */
  # guint16 version_major;  /* major version number; currently 2 */
  # guint16 version_minor;  /* minor version number; currently 4 */
  # gint32  thiszone;       /* GMT to local correction; always 0 */
  # guint32 sigfigs;        /* accuracy of timestamps; always */
  # guint32 snaplen;        /* max length of captured packets, in octets; usually 65535 */
  # guint32 network;        /* data link type */
  defp dump_header(network_type) do
    <<
      @magic_number::unsigned-32,
      @version_major::unsigned-16,
      @version_minor::unsigned-16,
      _thiszone = 0::signed-32,
      _sigfigs = 0::unsigned-32,
      @max_packet_size::unsigned-32,
      network_type::unsigned-32
    >>
  end

  defp record(packet) do
    packet_header(packet) <> packet.data
  end

  @usecs_in_sec 1000 * 1000

  # guint32 ts_sec;         /* timestamp seconds */
  # guint32 ts_usec;        /* timestamp microseconds */
  # guint32 incl_len;       /* number of octets of packet saved in file */
  # guint32 orig_len;       /* actual length of packet */
  defp packet_header(packet) do
    ts_sec = trunc(packet.timestamp_usec / @usecs_in_sec)
    ts_usec = packet.timestamp_usec - ts_sec * @usecs_in_sec

    <<
      ts_sec::unsigned-32,
      ts_usec::unsigned-32,
      _incl_len = byte_size(packet.data)::unsigned-32,
      _orig_len = byte_size(packet.data)::unsigned-32
    >>
  end

  defp parse_records(data, results \\ [])
  defp parse_records(_data = <<>>, results), do: Enum.reverse(results)

  defp parse_records(data, results) do
    <<
      ts_sec::unsigned-32,
      ts_usec::unsigned-32,
      incl_len::unsigned-32,
      orig_len::unsigned-32,
      packet_data::binary-size(incl_len),
      rest_data::binary
    >> = data

    timestamp_usec = ts_sec * @usecs_in_sec + ts_usec
    packet = Packet.new(packet_data, timestamp_usec, orig_len)

    parse_records(rest_data, [packet | results])
  end
end
