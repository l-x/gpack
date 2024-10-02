import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(#(Bool, BitArray), Error) {
  case message {
    <<0xC2, xs:bytes>> -> Ok(#(False, xs))
    <<0xC3, xs:bytes>> -> Ok(#(True, xs))
    _ -> Error(InvalidType)
  }
}
