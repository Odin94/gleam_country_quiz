import gleam/result
import gleam/dict.{type Dict}
import gleam/int
import gleam/dynamic.{type Decoder}
import gleam/list
import gleam/string

/// This decoder will attempt to decode a gleam `Dict` using the provided decoders.
pub fn decoder(
  key_decoder: Decoder(k),
  val_decoder: Decoder(v),
) -> Decoder(Dict(k, v)) {
  fn(data) {
    // First decode into a `Dict(Dynamic, Dynamic)`
    use dynamic_dict <- result.try(dynamic.dict(
      dynamic.dynamic,
      dynamic.dynamic,
    )(data))

    let entries = dict.to_list(dynamic_dict)

    // Fold over that dynamic entries list. The accumulator will be the desired
    // `Dict(k, v)`
    use data, #(dyn_key, dyn_val) <- list.try_fold(entries, dict.new())

    // Attempt to decode the current value
    case key_decoder(dyn_key), val_decoder(dyn_val) {
      // If it succeeds insert the new entry
      Ok(key), Ok(val) -> Ok(dict.insert(data, key, val))

      // If the key is not an int, ignore it (there are special string keys that
      // we want to ignore)
      Error(_), _ -> Ok(data)

      _, Error(ret2) ->
        Error([dynamic.DecodeError("Decodable value", string.inspect(ret2), [])])
    }
  }
}

/// A decoder that accepts strings that contain integers.
pub fn string_int_decoder() -> Decoder(Int) {
  fn(data) {
    use strval <- result.try(dynamic.string(data))
    int.parse(strval)
    |> result.replace_error([
      dynamic.DecodeError(
        expected: "A string representing an int",
        found: strval,
        path: [],
      ),
    ])
  }
}
