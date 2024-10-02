import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_bool as subject

pub fn main() {
  gleeunit.main()
}

fn should_decode_to(message: BitArray, value: Bool) -> Nil {
  message
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(value, <<>>))
}

pub fn decode_invalid_test() {
  <<0xC1>>
  |> subject.decode
  |> should.be_error
  |> should.equal(InvalidType)
}

pub fn decode_test() {
  <<0xC2>> |> should_decode_to(False)
  <<0xC3>> |> should_decode_to(True)
}
