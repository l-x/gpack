import gleam/bit_array
import gleam/result
import gpack/bytes
import gpack/error.{type Error, InvalidData, InvalidType}

pub fn decode(message: BitArray) -> Result(#(String, BitArray), Error) {
  case message {
    <<x, xs:bytes>> if x >= 0xA0 && x <= 0xBF -> {
      let size = x - 0xA0
      read(<<size, xs:bits>>, bytes.int8)
    }
    <<0xD9, xs:bytes>> -> read(xs, bytes.int8)
    <<0xDA, xs:bytes>> -> read(xs, bytes.int16)
    <<0xDB, xs:bytes>> -> read(xs, bytes.int32)
    _ -> Error(InvalidType)
  }
}

fn read(
  data: BitArray,
  size_fn: fn(BitArray) -> Result(#(Int, BitArray), Error),
) -> Result(#(String, BitArray), Error) {
  use #(data, rest) <- result.try(bytes.read(data, size_fn))
  use str <- result.try(
    bit_array.to_string(data) |> result.replace_error(InvalidData),
  )

  Ok(#(str, rest))
}
