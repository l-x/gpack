import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_int as subject

pub fn main() {
  gleeunit.main()
}

pub fn decode_positive_fixint_test() {
  <<0x00>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(0, <<>>))

  <<0x7f>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(127, <<>>))
}

pub fn decode_negative_fixint_test() {
  <<0xE0>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(-32, <<>>))

  <<0xFF>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(-1, <<>>))
}
