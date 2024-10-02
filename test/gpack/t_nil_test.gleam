import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_nil as subject

pub fn main() {
  gleeunit.main()
}

pub fn decode_test() {
  <<0xC0>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(Nil, <<>>))

  <<0xC0, 0xFF, 0xFE>>
  |> subject.decode
  |> should.be_ok
  |> should.equal(#(Nil, <<0xFF, 0xFE>>))

  <<0xFF>>
  |> subject.decode
  |> should.be_error
  |> should.equal(InvalidType)
}
