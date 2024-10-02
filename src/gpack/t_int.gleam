import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(#(Int, BitArray), Error) {
  case message {
    // positive fixint
    <<x, xs:bits>> if x <= 0x7F -> Ok(#(x, xs))
    // negative fixint
    <<x, xs:bits>> if x >= 0xE0 -> Ok(#(x - 0x0100, xs))
    _ -> Error(InvalidType)
  }
}
