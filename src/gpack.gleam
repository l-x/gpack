import gleam/dynamic.{type Dynamic}
import gleam/io
import gpack/error.{type Error}
import gpack/t_bool
import gpack/t_float
import gpack/t_int
import gpack/t_nil
import gpack/t_str

fn try_decode(
  message: BitArray,
  with decoder: fn(BitArray) -> Result(#(a, BitArray), Error),
  otherwise fun: fn() -> Result(#(Dynamic, BitArray), Error),
) -> Result(#(Dynamic, BitArray), Error) {
  case decoder(message) {
    Error(error.InvalidType) -> fun()
    Error(err) -> Error(err)
    Ok(#(x, xs)) -> Ok(#(dynamic.from(x), xs))
  }
}

pub fn decode_one(message: BitArray) -> Result(#(Dynamic, BitArray), Error) {
  use <- try_decode(message, with: t_nil.decode)
  use <- try_decode(message, with: t_bool.decode)
  use <- try_decode(message, with: t_int.decode)
  use <- try_decode(message, with: t_float.decode)
  use <- try_decode(message, with: t_str.decode)

  Error(error.UnknownType)
}

pub fn main() {
  let msg = <<0xDA, 0x03, "abc":utf8>>

  msg
  |> decode_one
  |> io.debug
}
