import gleam/bool.{guard}
import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/result.{try}
import gpack/binary
import gpack/boolean
import gpack/bytes
import gpack/error.{type Error, UnexpectedEndOfData, UnknownType}
import gpack/extension
import gpack/float
import gpack/integer
import gpack/nil
import gpack/string

type DecodeResult(a) =
  Result(#(a, BitArray), Error)

fn try_decode(
  from data: BitArray,
  using decode: fn(BitArray) -> Result(#(a, BitArray), Error),
  otherwise continue: fn() -> DecodeResult(Dynamic),
) -> DecodeResult(Dynamic) {
  case decode(data) {
    Ok(#(x, xs)) -> Ok(#(dynamic.from(x), xs))
    Error(UnknownType) -> continue()
    Error(err) -> Error(err)
  }
}

fn decode_array(from data: BitArray) -> DecodeResult(List(Dynamic)) {
  let do_decode = fn(data, size_decoder) {
    use #(length, data) <- try(size_decoder(data))
    use #(x, xs) <- try(decode_n(data, length, []))

    Ok(#(x, xs))
  }

  case data {
    <<x, xs:bytes>> if x >= 0x90 && x <= 0x9F ->
      do_decode(<<{ x - 0x90 }:big-size(16), xs:bits>>, bytes.uint16)
    <<0xDC, xs:bytes>> -> do_decode(xs, bytes.uint16)
    <<0xDD, xs:bytes>> -> do_decode(xs, bytes.uint32)
    _ -> Error(UnknownType)
  }
}

fn decode_map(from data: BitArray) -> DecodeResult(Dict(Dynamic, Dynamic)) {
  let do_decode = fn(data, size_decoder) {
    use #(length, data) <- try(size_decoder(data))
    use #(list, xs) <- try(decode_n(data, length * 2, []))

    let x =
      list.sized_chunk(list, 2)
      |> list.map(fn(p) {
        let assert [k, v] = p
        #(k, v)
      })
      |> dict.from_list

    Ok(#(x, xs))
  }

  case data {
    <<x, xs:bytes>> if x >= 0x80 && x <= 0x8F ->
      do_decode(<<{ x - 0x80 }:big-size(16), xs:bits>>, bytes.uint16)
    <<0xDE, xs:bytes>> -> do_decode(xs, bytes.uint16)
    <<0xDF, xs:bytes>> -> do_decode(xs, bytes.uint32)
    _ -> Error(UnknownType)
  }
}

fn decode_n(
  data: BitArray,
  n: Int,
  acc: List(Dynamic),
) -> DecodeResult(List(Dynamic)) {
  use <- guard(when: n == 0, return: Ok(#(list.reverse(acc), data)))
  use <- guard(when: data == <<>>, return: Error(UnexpectedEndOfData))

  case decode_one(data) {
    Ok(#(x, xs)) -> decode_n(xs, n - 1, [x, ..acc])
    Error(err) -> Error(err)
  }
}

pub fn decode_one(message: BitArray) -> DecodeResult(Dynamic) {
  use <- bool.guard(when: message == <<>>, return: Error(UnexpectedEndOfData))

  use <- try_decode(message, using: nil.decode)
  use <- try_decode(message, using: boolean.decode)
  use <- try_decode(message, using: integer.decode)
  use <- try_decode(message, using: float.decode)
  use <- try_decode(message, using: string.decode)
  use <- try_decode(message, using: binary.decode)
  use <- try_decode(message, using: extension.decode)
  use <- try_decode(message, using: decode_array)
  use <- try_decode(message, using: decode_map)

  Error(UnknownType)
}
