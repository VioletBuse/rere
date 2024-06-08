import gleam/dynamic.{type Dynamic}
import gleam/io

pub type RefResolutionError {
  InvalidRef
}

pub fn resolve(
  dynamic: Dynamic,
  path: String,
) -> Result(Dynamic, RefResolutionError) {
  todo
}

type Ref

fn parse_ref_str(input: String) -> Result(Ref, Nil) {
  todo
}
