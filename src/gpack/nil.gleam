import gpack/error.{type Error, UnknownType}

pub fn decode(from data: BitArray) -> Result(#(Nil, BitArray), Error) {
  case data {
    <<0xC0, xs:bytes>> -> Ok(#(Nil, xs))
    _ -> Error(UnknownType)
  }
}

pub fn encode(this _value: Nil) -> BitArray {
  <<0xC0>>
}
