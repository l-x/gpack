import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(#(Bool, BitArray), Error) {
  case message {
    <<0xC2, rest:bits>> -> Ok(#(False, rest))
    <<0xC3, rest:bits>> -> Ok(#(True, rest))
    _ -> Error(InvalidType)
  }
}
