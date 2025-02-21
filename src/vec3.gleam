import gleam/float
import gleam/result

pub type Vector3 =
  #(Float, Float, Float)

pub const zero = #(0.0, 0.0, 0.0)

pub fn add(v: Vector3, w: Vector3) -> Vector3 {
  #(v.0 +. w.0, v.1 +. w.1, v.2 +. w.2)
}

pub fn substract(v: Vector3, w: Vector3) -> Vector3 {
  #(v.0 -. w.0, v.1 -. w.1, v.2 -. w.2)
}

pub fn times(v: Vector3, w: Vector3) -> Vector3 {
  #(v.0 *. w.0, v.1 *. w.1, v.2 *. w.2)
}

pub fn negate(v: Vector3) -> Vector3 {
  substract(zero, v)
}

pub fn cross(v: Vector3, w: Vector3) -> Vector3 {
  #(
    v.1 *. w.2 -. v.2 *. w.1,
    v.2 *. w.0 -. v.0 *. w.2,
    v.0 *. w.1 -. v.1 *. w.0,
  )
}

pub fn dot(v: Vector3, w: Vector3) -> Float {
  v.0 *. w.0 +. v.1 *. w.1 +. v.2 *. w.2
}

pub fn square_length(v: Vector3) -> Float {
  dot(v, v)
}

pub fn length(v: Vector3) -> Float {
  v
  |> square_length
  |> float.square_root
  |> result.unwrap(0.0)
}

pub fn scale(v: Vector3, factor: Float) -> Vector3 {
  #(factor, factor, factor)
  |> times(v)
}

pub fn normalize(v: Vector3) -> Vector3 {
  let inv_length = length(v)
  scale(v, inv_length)
}

pub fn orthogonal(v: Vector3) -> Vector3 {
  cross(v, #(v.0 +. 0.1, v.1, v.2))
}
