import gpack/bytes
import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(#(Float, BitArray), Error) {
  case message {
    <<0xCA, xs:bytes>> -> xs |> bytes.float32
    <<0xCB, xs:bytes>> -> xs |> bytes.float64
    _ -> Error(InvalidType)
  }
}
