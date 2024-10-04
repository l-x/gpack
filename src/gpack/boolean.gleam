import gpack/error.{type Error, UnknownType}

pub fn decode(from data: BitArray) -> Result(#(Bool, BitArray), Error) {
  case data {
    <<0xC2, xs:bytes>> -> Ok(#(False, xs))
    <<0xC3, xs:bytes>> -> Ok(#(True, xs))
    _ -> Error(UnknownType)
  }
}

pub fn encode(this value: Bool) -> BitArray {
  case value {
    False -> <<0xC2>>
    True -> <<0xC3>>
  }
}
