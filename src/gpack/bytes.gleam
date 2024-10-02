import gleam/bit_array.{byte_size, slice}
import gleam/result.{map_error, try, unwrap}
import gpack/error.{type Error, UnexpectedEndOfData}

fn splice(data: BitArray, at bytes: Int) -> Result(#(BitArray, BitArray), Error) {
  use x <- try(
    data
    |> slice(at: 0, take: bytes)
    |> map_error(fn(_) { UnexpectedEndOfData(bytes, data |> byte_size) }),
  )

  let xs =
    data
    |> slice(at: bytes, take: byte_size(data) - bytes)
    |> unwrap(<<>>)

  Ok(#(x, xs))
}

pub fn read(
  data: BitArray,
  size_fn: fn(BitArray) -> Result(#(Int, BitArray), Error),
) -> Result(#(BitArray, BitArray), Error) {
  use #(size, data) <- try(size_fn(data))

  data |> splice(at: size)
}

pub fn int8(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(1))
  let assert <<s:signed-big-size(8)>> = x

  Ok(#(s, xs))
}

pub fn uint8(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(1))
  let assert <<s:unsigned-big-size(8)>> = x

  Ok(#(s, xs))
}

pub fn uint16(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(2))
  let assert <<s:unsigned-big-size(16)>> = x

  Ok(#(s, xs))
}

pub fn int16(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(2))
  let assert <<s:signed-big-size(16)>> = x

  Ok(#(s, xs))
}

pub fn uint32(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(4))
  let assert <<s:unsigned-big-size(32)>> = x

  Ok(#(s, xs))
}

pub fn int32(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(4))
  let assert <<s:signed-big-size(32)>> = x

  Ok(#(s, xs))
}

pub fn uint64(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(8))
  let assert <<s:unsigned-big-size(64)>> = x

  Ok(#(s, xs))
}

pub fn int64(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(8))
  let assert <<s:signed-big-size(64)>> = x

  Ok(#(s, xs))
}

pub fn float32(data: BitArray) -> Result(#(Float, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(4))
  let assert <<s:float-big-size(32)>> = x

  Ok(#(s, xs))
}

pub fn float64(data: BitArray) -> Result(#(Float, BitArray), Error) {
  use #(x, xs) <- try(data |> splice(8))
  let assert <<s:float-big-size(64)>> = x

  Ok(#(s, xs))
}
