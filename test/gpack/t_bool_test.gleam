import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_bool as subject

pub fn main() {
  gleeunit.main()
}

pub fn decode_test() {
  <<0xC2>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(False, <<>>))

  <<0xC2, 0xFF, 0xFE>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(False, <<0xFF, 0xFE>>))

  <<0xC3>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(True, <<>>))

  <<0xC3, 0xFF, 0xFE>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(True, <<0xFF, 0xFE>>))

  <<0xFF>>
  |> subject.decode
  |> should.be_error
  |> should.equal(InvalidType)
}
