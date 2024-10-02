import gleam/dynamic.{type Dynamic}
import gleam/io
import gpack/error.{type Error, InvalidMessage}
import gpack/t_bool
import gpack/t_nil

fn try_decode(
  decoder: fn(BitArray) -> Result(a, Error),
  message: BitArray,
  otherwise: fn() -> Result(Dynamic, Error),
) -> Result(Dynamic, Error) {
  case decoder(message) {
    Error(_) -> otherwise()
    Ok(x) -> Ok(dynamic.from(x))
  }
}

pub fn decode(message: BitArray) -> Result(Dynamic, Error) {
  use <- try_decode(t_nil.decode, message)
  use <- try_decode(t_bool.decode, message)

  Error(InvalidMessage)
}

pub fn main() {
  <<0xC2, 0xC2, 0xC3>>
  |> decode
  |> io.debug
}
