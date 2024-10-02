import gleeunit
import gleeunit/should
import gpack/error.{InvalidType}
import gpack/t_int as subject

pub fn main() {
  gleeunit.main()
}

fn should_decode_to(message: BitArray, value: Int) -> Nil {
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

pub fn decode_positive_fixint_test() {
  <<0x00>> |> should_decode_to(0)
  <<0x7f>> |> should_decode_to(127)
}

pub fn decode_negative_fixint_test() {
  <<0xE0>> |> should_decode_to(-32)
  <<0xFF>> |> should_decode_to(-1)
}

pub fn decode_uint8_test() {
  <<0xCC, 0x00>> |> should_decode_to(0)
  <<0xCC, 0xFF>> |> should_decode_to(255)
}

pub fn decode_uint16_test() {
  <<0xCD, 0x00, 0x00>> |> should_decode_to(0)
  <<0xCD, 0x01, 0x00>> |> should_decode_to(256)
  <<0xCD, 0xFF, 0xFF>> |> should_decode_to(65_535)
}

pub fn decode_uint32_test() {
  <<0xCE, 0x00, 0x00, 0x00, 0x00>> |> should_decode_to(0)
  <<0xCE, 0x00, 0x01, 0x00, 0x00>> |> should_decode_to(65_536)
  <<0xCE, 0xFF, 0xFF, 0xFF, 0xFF>> |> should_decode_to(4_294_967_295)
}

pub fn decode_uint64_test() {
  <<0xCF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>
  |> should_decode_to(0)
  <<0xCF, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00>>
  |> should_decode_to(4_294_967_296)
  <<0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>
  |> should_decode_to(18_446_744_073_709_551_615)
}

pub fn decode_int8_test() {
  <<0xD0, 0x00>> |> should_decode_to(0)
  <<0xD0, 0x7F>> |> should_decode_to(127)
  <<0xD0, 0x80>> |> should_decode_to(-128)
}

pub fn decode_int16_test() {
  <<0xD1, 0x00, 0x00>> |> should_decode_to(0)
  <<0xD1, 0x7F, 0xFF>> |> should_decode_to(32_767)
  <<0xD1, 0x80, 0x00>> |> should_decode_to(-32_768)
}

pub fn decode_int32_test() {
  <<0xD2, 0x00, 0x00, 0x00, 0x00>> |> should_decode_to(0)
  <<0xD2, 0x7F, 0xFF, 0xFF, 0xFF>> |> should_decode_to(2_147_483_647)
  <<0xD2, 0x80, 0x00, 0x00, 0x00>> |> should_decode_to(-2_147_483_648)
}

pub fn decode_int64_test() {
  <<0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>
  |> should_decode_to(0)
  <<0xD3, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>
  |> should_decode_to(9_223_372_036_854_775_807)
  <<0xD3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>
  |> should_decode_to(-9_223_372_036_854_775_808)
}
