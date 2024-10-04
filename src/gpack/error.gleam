import gleam/dynamic

pub type Error {
  UnknownType
  InvalidType
  InvalidMessage
  UnexpectedEndOfData
  InvalidData
  DecodeErrors(List(dynamic.DecodeError))
}
