import gleam/bit_array
import gleam/result.{replace_error, try}
import gpack/bytes
import gpack/error.{type Error, InvalidData, UnknownType}

pub fn decode(from data: BitArray) -> Result(#(String, BitArray), Error) {
  case data {
    <<x, xs:bytes>> if x >= 0xA0 && x <= 0xBF ->
      do_decode(from: <<{ x - 0xA0 }, xs:bits>>, using: bytes.uint8)
    <<0xD9, xs:bytes>> -> do_decode(from: xs, using: bytes.uint8)
    <<0xDA, xs:bytes>> -> do_decode(from: xs, using: bytes.uint16)
    <<0xDB, xs:bytes>> -> do_decode(from: xs, using: bytes.uint32)
    _ -> Error(UnknownType)
  }
}

fn do_decode(from data, using size_decoder) {
  use #(data, xs) <- try(bytes.splice(data, using: size_decoder))

  use x <- try(
    bit_array.to_string(data)
    |> replace_error(InvalidData),
  )

  Ok(#(x, xs))
}
