import gleam/dynamic.{type Decoder}
import gleam/result.{try}
import gpack/decoder.{decode_one}
import gpack/error.{type Error, DecodeErrors}

pub fn stream_decode(
  from data: BitArray,
  using decode: Decoder(a),
) -> Result(#(a, BitArray), Error) {
  use #(x, xs) <- try(decode_one(data))

  case decode(x) {
    Ok(x) -> Ok(#(x, xs))
    Error(errors) -> Error(DecodeErrors(errors))
  }
}

pub fn decode(from data: BitArray, using decode: Decoder(a)) -> Result(a, Error) {
  use #(x, _) <- try(stream_decode(data, using: decode))

  Ok(x)
}
