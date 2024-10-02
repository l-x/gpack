import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(Bool, Error) {
  case message {
    <<0xC2, _:bits>> -> Ok(False)
    <<0xC3, _:bits>> -> Ok(True)
    _ -> Error(InvalidType)
  }
}
