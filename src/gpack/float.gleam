import gleam/result.{try}
import gpack/bytes
import gpack/error.{type Error, UnknownType}

pub fn decode(from data: BitArray) -> Result(#(Float, BitArray), Error) {
  case data {
    <<0xCA, xs:bytes>> -> do_decode(from: xs, using: bytes.float32)
    <<0xCB, xs:bytes>> -> do_decode(from: xs, using: bytes.float64)
    _ -> Error(UnknownType)
  }
}

fn do_decode(from message, using decoder) {
  use #(x, xs) <- try(decoder(message))

  Ok(#(x, xs))
}
