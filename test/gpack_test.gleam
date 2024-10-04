import gleam/bit_array
import gleam/dict
import gleam/dynamic
import gleam/list
import gleeunit
import gleeunit/should
import gpack
import gpack/testdata

pub fn main() {
  gleeunit.main()
}

fn run_testcase(with data: List(#(a, List(BitArray))), using decoder) -> Nil {
  list.each(data, fn(testcase) {
    list.each(testcase.1, fn(data) {
      data
      |> gpack.decode(using: decoder)
      |> should.be_ok
      |> should.equal(testcase.0)
    })
  })
}

pub fn decode_bool_test() {
  run_testcase(with: testdata.boolean, using: dynamic.bool)
}

pub fn decode_float_test() {
  run_testcase(with: testdata.float, using: dynamic.float)
}

pub fn decode_str_test() {
  run_testcase(with: testdata.string, using: dynamic.string)
}

pub fn decode_binary_test() {
  run_testcase(with: testdata.binary, using: dynamic.bit_array)
}

pub fn decode_array_test() {
  run_testcase(with: testdata.array, using: dynamic.list(of: dynamic.int))
}

pub fn decode_map_test() {
  run_testcase(
    with: testdata.map |> list.map(fn(p) { #(dict.from_list(p.0), p.1) }),
    using: dynamic.dict(dynamic.string, dynamic.string),
  )
}

pub fn decode_ext_test() {
  run_testcase(
    with: testdata.extension,
    using: dynamic.tuple2(dynamic.int, dynamic.bit_array),
  )
}

pub fn decode_integer_test() {
  run_testcase(with: testdata.integer, using: dynamic.int)
}

pub fn nested_arrays_and_objects_test() {
  "gaF4kYGheYGhepGhYQ=="
  |> bit_array.base64_decode
  |> should.be_ok
  |> gpack.decode(using: dynamic.dynamic)
  |> should.be_ok
  |> should.equal(
    dynamic.from(
      dict.from_list([
        #("x", [dict.from_list([#("y", dict.from_list([#("z", ["a"])]))])]),
      ]),
    ),
  )
}
