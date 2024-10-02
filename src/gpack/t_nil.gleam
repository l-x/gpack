import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(Nil, Error) {
  case message {
    <<0xC0, _:bits>> -> Ok(Nil)
    _ -> Error(InvalidType)
  }
}
