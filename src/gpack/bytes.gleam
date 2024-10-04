import gleam/bit_array.{byte_size, slice}
import gleam/result.{replace_error, try, unwrap}
import gpack/error.{type Error, UnexpectedEndOfData}

fn do_splice(
  data: BitArray,
  at bytes: Int,
) -> Result(#(BitArray, BitArray), Error) {
  use x <- try(
    slice(from: data, at: 0, take: bytes)
    |> replace_error(UnexpectedEndOfData),
  )

  let xs =
    slice(from: data, at: bytes, take: byte_size(data) - bytes)
    |> unwrap(<<>>)

  Ok(#(x, xs))
}

pub fn splice(
  data: BitArray,
  using size_fn: fn(BitArray) -> Result(#(Int, BitArray), Error),
) -> Result(#(BitArray, BitArray), Error) {
  use #(size, data) <- try(size_fn(data))

  data |> do_splice(at: size)
}

pub fn int8(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(1))
  let assert <<s:signed-big-size(8)>> = x

  Ok(#(s, xs))
}

pub fn uint8(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(1))
  let assert <<s:unsigned-big-size(8)>> = x

  Ok(#(s, xs))
}

pub fn uint16(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(2))
  let assert <<s:unsigned-big-size(16)>> = x

  Ok(#(s, xs))
}

pub fn int16(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(2))
  let assert <<s:signed-big-size(16)>> = x

  Ok(#(s, xs))
}

pub fn uint32(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(4))
  let assert <<s:unsigned-big-size(32)>> = x

  Ok(#(s, xs))
}

pub fn int32(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(4))
  let assert <<s:signed-big-size(32)>> = x

  Ok(#(s, xs))
}

pub fn uint64(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(8))
  let assert <<s:unsigned-big-size(64)>> = x

  Ok(#(s, xs))
}

pub fn int64(data: BitArray) -> Result(#(Int, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(8))
  let assert <<s:signed-big-size(64)>> = x

  Ok(#(s, xs))
}

pub fn float32(data: BitArray) -> Result(#(Float, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(4))
  let assert <<s:float-big-size(32)>> = x

  Ok(#(s, xs))
}

pub fn float64(data: BitArray) -> Result(#(Float, BitArray), Error) {
  use #(x, xs) <- try(data |> do_splice(8))
  let assert <<s:float-big-size(64)>> = x

  Ok(#(s, xs))
}
