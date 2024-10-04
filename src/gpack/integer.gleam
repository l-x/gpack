import gleam/result.{try}
import gpack/bytes
import gpack/error.{type Error, UnknownType}

pub fn decode(from data: BitArray) -> Result(#(Int, BitArray), Error) {
  case data {
    <<x, xs:bytes>> if x <= 0x7F -> Ok(#(x, xs))
    <<x, xs:bytes>> if x >= 0xE0 -> Ok(#(x - 0x100, xs))
    <<0xCC, xs:bytes>> -> do_decode(from: xs, using: bytes.uint8)
    <<0xCD, xs:bytes>> -> do_decode(from: xs, using: bytes.uint16)
    <<0xCE, xs:bytes>> -> do_decode(from: xs, using: bytes.uint32)
    <<0xCF, xs:bytes>> -> do_decode(from: xs, using: bytes.uint64)
    <<0xD0, xs:bytes>> -> do_decode(from: xs, using: bytes.int8)
    <<0xD1, xs:bytes>> -> do_decode(from: xs, using: bytes.int16)
    <<0xD2, xs:bytes>> -> do_decode(from: xs, using: bytes.int32)
    <<0xD3, xs:bytes>> -> do_decode(from: xs, using: bytes.int64)
    _ -> Error(UnknownType)
  }
}

fn do_decode(from message, using decoder) {
  use #(x, xs) <- try(decoder(message))

  Ok(#(x, xs))
}
