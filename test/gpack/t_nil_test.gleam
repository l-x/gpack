import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_nil as subject

pub fn main() {
  gleeunit.main()
}

pub fn decode_invalid_test() {
  <<0xC1>>
  |> subject.decode
  |> should.be_error
  |> should.equal(InvalidType)
}

pub fn decode_test() {
  <<0xC0>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(Nil)
}
