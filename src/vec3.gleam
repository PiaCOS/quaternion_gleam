import gleam/float
import gleam/result

/// The Vector3 alias.
pub type Vector3 =
  #(Float, Float, Float)

pub const zero = #(0.0, 0.0, 0.0)

/// Adds two vectors.
pub fn add(v: Vector3, w: Vector3) -> Vector3 {
  #(v.0 +. w.0, v.1 +. w.1, v.2 +. w.2)
}

/// Substracts two vectors.
pub fn substract(v: Vector3, w: Vector3) -> Vector3 {
  #(v.0 -. w.0, v.1 -. w.1, v.2 -. w.2)
}

/// Multiplies (element-wise) two vectors.
pub fn times(v: Vector3, w: Vector3) -> Vector3 {
  #(v.0 *. w.0, v.1 *. w.1, v.2 *. w.2)
}

/// Negates a vector.
pub fn negate(v: Vector3) -> Vector3 {
  substract(zero, v)
}

/// Computes the cross product of two vectors.
pub fn cross(v: Vector3, w: Vector3) -> Vector3 {
  #(
    v.1 *. w.2 -. v.2 *. w.1,
    v.2 *. w.0 -. v.0 *. w.2,
    v.0 *. w.1 -. v.1 *. w.0,
  )
}

/// Computes the dot product of two vectors.
pub fn dot(v: Vector3, w: Vector3) -> Float {
  v.0 *. w.0 +. v.1 *. w.1 +. v.2 *. w.2
}

/// Computes the squared length of a vector.
pub fn square_length(v: Vector3) -> Float {
  dot(v, v)
}

/// Computes the length of a vector.
pub fn length(v: Vector3) -> Float {
  v
  |> square_length
  |> float.square_root
  |> result.unwrap(0.0)
}

/// Scales a vector by a factor.
pub fn scale(v: Vector3, factor: Float) -> Vector3 {
  #(factor, factor, factor)
  |> times(v)
}

/// Normalizes a vector.
pub fn normalize(v: Vector3) -> Vector3 {
  let inv_length = length(v)
  scale(v, inv_length)
}

/// Find one of the orthogonal vectors to the given vector.
pub fn orthogonal(v: Vector3) -> Vector3 {
  cross(v, #(v.0 +. 0.1, v.1, v.2))
}

/// Asserts if vector3 are loosely equals
pub fn loosely_equals(v: Vector3, w: Vector3, epsilon: Float) -> Bool {
  float.loosely_equals(v.0, w.0, epsilon)
  && float.loosely_equals(v.1, w.1, epsilon)
  && float.loosely_equals(v.2, w.2, epsilon)
}
