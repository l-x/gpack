import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(#(Nil, BitArray), Error) {
  case message {
    <<0xC0, xs:bytes>> -> Ok(#(Nil, xs))
    _ -> Error(InvalidType)
  }
}
