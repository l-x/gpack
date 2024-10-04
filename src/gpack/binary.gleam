import gleam/result.{try}
import gpack/bytes
import gpack/error.{type Error, UnknownType}

pub fn decode(from data: BitArray) -> Result(#(BitArray, BitArray), Error) {
  case data {
    <<0xC4, xs:bytes>> -> do_decode(from: xs, using: bytes.uint8)
    <<0xC5, xs:bytes>> -> do_decode(from: xs, using: bytes.uint16)
    <<0xC6, xs:bytes>> -> do_decode(from: xs, using: bytes.uint32)
    _ -> Error(UnknownType)
  }
}

fn do_decode(from data, using size_decoder) {
  use #(x, xs) <- try(bytes.splice(data, using: size_decoder))

  Ok(#(x, xs))
}
