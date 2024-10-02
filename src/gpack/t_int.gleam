import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(Int, Error) {
  case message {
    <<x, _:bits>> if x <= 0x7F -> Ok(x)
    <<x, _:bits>> if x >= 0xE0 -> Ok(x - 0x0100)

    <<0xCC, x:unsigned-big-size(8), _:bits>>
    | <<0xCD, x:unsigned-big-size(16), _:bits>>
    | <<0xCE, x:unsigned-big-size(32), _:bits>>
    | <<0xCF, x:unsigned-big-size(64), _:bits>> -> Ok(x)
    _ -> Error(InvalidType)
  }
}
