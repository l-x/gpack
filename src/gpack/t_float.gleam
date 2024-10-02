import gpack/error.{type Error, InvalidType}

pub fn decode(message: BitArray) -> Result(Float, Error) {
  case message {
    <<0xCA, x:float-big-size(32), _:bits>>
    | <<0xCB, x:float-big-size(64), _:bits>> -> Ok(x)

    _ -> Error(InvalidType)
  }
}
