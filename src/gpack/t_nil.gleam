import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(#(Nil, BitArray), Error) {
  case message {
    <<0xC0, rest:bits>> -> Ok(#(Nil, rest))
    _ -> Error(InvalidType)
  }
}
