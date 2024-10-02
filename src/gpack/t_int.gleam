import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(Int, Error) {
  case message {
    // positive fixint
    <<x, _:bits>> if x <= 0x7F -> Ok(x)
    // negative fixint
    <<x, _:bits>> if x >= 0xE0 -> Ok(x - 0x0100)
    _ -> Error(InvalidType)
  }
}
