import gleam/dynamic.{type Dynamic}
import gleam/int
import gleam/list
import gleam/result

pub type JsonNode {
  Leaf(value: Dynamic)
  Branch(values: List(#(String, JsonNode)))
}

fn decode_object_branch(dyn: Dynamic) -> Result(JsonNode, Nil) {
  use list <- result.try(
    dynamic.list(dynamic.tuple2(dynamic.string, dynamic.dynamic))(dyn)
    |> result.nil_error,
  )
  let values =
    list.map(list, fn(content) {
      #(content.0, decode_to_internal_repr(content.1))
    })

  Ok(Branch(values))
}

fn decode_list_branch(dyn: Dynamic) -> Result(JsonNode, Nil) {
  use list <- result.try(dynamic.shallow_list(dyn) |> result.nil_error)
  let values =
    list.index_map(list, fn(dyn, idx) {
      #(int.to_string(idx), decode_to_internal_repr(dyn))
    })

  Ok(Branch(values))
}

pub fn decode_to_internal_repr(dyn: Dynamic) -> JsonNode {
  let branches = {
    use _ <- result.try_recover(decode_object_branch(dyn))
    use _ <- result.try_recover(decode_list_branch(dyn))
    Error(Nil)
  }

  case branches {
    Ok(branch) -> branch
    Error(_) -> Leaf(dyn)
  }
}
