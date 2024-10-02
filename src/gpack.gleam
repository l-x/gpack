import gleam/bool
import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/list
import gpack/error.{type Error, InvalidMessage}
import gpack/t_bool
import gpack/t_nil

type DecoderResult(a) =
  Result(#(a, BitArray), Error)

type Decoder(a) =
  fn(BitArray) -> DecoderResult(a)

pub fn decode(message: BitArray) -> Result(List(Dynamic), Error) {
  decode_recursive(message, [])
}

fn try_decode(
  decoder: Decoder(a),
  message: BitArray,
  otherwise: fn() -> DecoderResult(Dynamic),
) -> DecoderResult(Dynamic) {
  case decoder(message) {
    Error(_) -> otherwise()
    Ok(#(x, rest)) -> Ok(#(dynamic.from(x), rest))
  }
}

fn decode_next(message: BitArray) -> DecoderResult(Dynamic) {
  use <- try_decode(t_nil.decode, message)
  use <- try_decode(t_bool.decode, message)

  Error(InvalidMessage)
}

fn decode_recursive(
  message: BitArray,
  acc: List(Dynamic),
) -> Result(List(Dynamic), Error) {
  use <- bool.guard(when: message == <<>>, return: Ok(list.reverse(acc)))

  case decode_next(message) {
    Ok(#(x, xs)) -> decode_recursive(xs, [x, ..acc])
    Error(err) -> Error(err)
  }
}

pub fn main() {
  <<0xC0, 0xC2, 0xC3>>
  |> decode
  |> io.debug
}
