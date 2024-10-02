import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_float as subject

pub fn main() {
  gleeunit.main()
}

fn should_decode_to(message: BitArray, value: Float) -> Nil {
  message
  |> subject.decode
  |> should.be_ok
  |> should.equal(value)
}

pub fn decode_invalid_test() {
  <<0xC1>>
  |> subject.decode
  |> should.be_error
  |> should.equal(InvalidType)
}

pub fn decode_int32_test() {
  <<0xCA, 0x00, 0x00, 0x00, 0x00>> |> should_decode_to(0.0)
  <<0xCA, 0x80, 0x00, 0x00, 0x00>> |> should_decode_to(-0.0)
}

pub fn decode_int64_test() {
  <<0xCB, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>
  |> should_decode_to(0.0)
  <<0xCB, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>
  |> should_decode_to(-0.0)
}
