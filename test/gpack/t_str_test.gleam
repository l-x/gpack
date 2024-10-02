import gleam/bit_array
import gleam/io
import gleam/string
import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_str as subject

pub fn main() {
  gleeunit.main()
}

fn should_decode_to(message: BitArray, value: String) -> Nil {
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

pub fn decode_fixstr_test() {
  <<0xA0>> |> should_decode_to("")
  <<0xA4, "🎆">> |> should_decode_to("🎆")
  <<0xBF, "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx">>
  |> should_decode_to("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
}

pub fn decode_str8_test() {
  <<0xD9, 0:big-size(8)>> |> should_decode_to("")

  let test_string = "x" |> string.repeat(255)
  <<0xD9, 255:big-size(8), test_string:utf8>>
  |> should_decode_to(test_string)
}
