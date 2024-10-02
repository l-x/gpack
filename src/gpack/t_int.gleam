import gpack/bytes
import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(#(Int, BitArray), Error) {
  case message {
    <<x, xs:bytes>> if x <= 0x7F -> Ok(#(x, xs))
    <<x, xs:bytes>> if x >= 0xE0 -> Ok(#(x - 0x0100, xs))

    <<0xCC, xs:bytes>> -> xs |> bytes.uint8
    <<0xCD, xs:bytes>> -> xs |> bytes.uint16
    <<0xCE, xs:bytes>> -> xs |> bytes.uint32
    <<0xCF, xs:bytes>> -> xs |> bytes.uint64

    <<0xD0, xs:bytes>> -> xs |> bytes.int8
    <<0xD1, xs:bytes>> -> xs |> bytes.int16
    <<0xD2, xs:bytes>> -> xs |> bytes.int32
    <<0xD3, xs:bytes>> -> xs |> bytes.int64

    _ -> Error(InvalidType)
  }
}
