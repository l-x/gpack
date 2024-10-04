import gleam/result.{try}
import gpack/bytes
import gpack/error.{type Error, UnknownType}

pub fn decode(
  from data: BitArray,
) -> Result(#(#(Int, BitArray), BitArray), Error) {
  case data {
    <<0xD4, xs:bytes>> -> xs |> fixext(1)
    <<0xD5, xs:bytes>> -> xs |> fixext(2)
    <<0xD6, xs:bytes>> -> xs |> fixext(4)
    <<0xD7, xs:bytes>> -> xs |> fixext(8)
    <<0xD8, xs:bytes>> -> xs |> fixext(16)
    <<0xC7, xs:bytes>> -> xs |> ext(bytes.uint8)
    <<0xC8, xs:bytes>> -> xs |> ext(bytes.uint16)
    <<0xC9, xs:bytes>> -> xs |> ext(bytes.uint32)
    _ -> Error(UnknownType)
  }
}

fn fixext(data, length) {
  use #(ext_type, xs) <- try(bytes.uint8(data))
  use #(x, xs) <- try(bytes.splice(xs, fn(d) { Ok(#(length, d)) }))

  Ok(#(#(ext_type, x), xs))
}

fn ext(data, size_decoder) {
  use #(length, xs) <- try(size_decoder(data))
  use #(ext_type, xs) <- try(bytes.uint8(xs))
  use #(x, xs) <- try(bytes.splice(xs, fn(d) { Ok(#(length, d)) }))

  Ok(#(#(ext_type, x), xs))
}
