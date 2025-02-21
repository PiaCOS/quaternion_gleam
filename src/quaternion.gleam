import gleam/float
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam_community/maths/elementary
import vec3

pub type Quaternion {
  Quaternion(real: Float, imaginary: #(Float, Float, Float))
}

pub const id = Quaternion(1.0, #(0.0, 0.0, 0.0))

pub fn from_list(q: List(Float)) -> Result(Quaternion, String) {
  case q {
    [x, i, j, k] -> Ok(Quaternion(x, #(i, j, k)))
    _ -> Error("A quaternion should have 4 elements")
  }
}

pub fn to_list(q: Quaternion) -> List(Float) {
  [q.real, q.imaginary.0, q.imaginary.1, q.imaginary.2]
}

pub fn to_string(q: Quaternion) -> String {
  q.real
  |> float.to_string
  |> string.append(" + ")
  |> string.append(float.to_string(q.imaginary.0))
  |> string.append("i + ")
  |> string.append(float.to_string(q.imaginary.1))
  |> string.append("j + ")
  |> string.append(float.to_string(q.imaginary.2))
  |> string.append("k")
}

/// Adds two quaternions
pub fn add(a: Quaternion, b: Quaternion) -> Quaternion {
  Quaternion(a.real +. b.real, vec3.add(a.imaginary, b.imaginary))
}

/// Substracts two quaternions
pub fn substract(a: Quaternion, b: Quaternion) -> Quaternion {
  Quaternion(a.real -. b.real, vec3.substract(a.imaginary, b.imaginary))
}

/// Computes the product (element-wise) of two quaternions.
pub fn times(a: Quaternion, b: Quaternion) -> Quaternion {
  Quaternion(a.real *. b.real, vec3.times(a.imaginary, b.imaginary))
}

/// Scales a quaternion (element-wise) by a scalar.
pub fn scale(q: Quaternion, factor: Float) -> Quaternion {
  Quaternion(factor, #(factor, factor, factor))
  |> times(q)
}

/// Computes the dot product of two quaternions.
pub fn dot(q: Quaternion, r: Quaternion) -> Float {
  q
  |> times(r)
  |> to_list
  |> list.fold(from: 0.0, with: float.add)
}

/// Computes the product of two quaternions.
pub fn multiply(q: Quaternion, r: Quaternion) -> Quaternion {
  // Real Part
  let real = q.real *. r.real -. vec3.dot(q.imaginary, r.imaginary)

  // Imaginary Part
  vec3.scale(r.imaginary, q.real)
  |> vec3.add(vec3.scale(q.imaginary, r.real))
  |> vec3.add(vec3.cross(q.imaginary, r.imaginary))
  |> Quaternion(real, _)
}

/// Computes the conjugate of a quaternion.
pub fn conjugate(q: Quaternion) -> Quaternion {
  Quaternion(q.real, vec3.negate(q.imaginary))
}

/// Computes the squared length of a quaternion.
pub fn square_length(q: Quaternion) -> Float {
  dot(q, q)
}

/// Computes the length of a quaternion.
pub fn length(q: Quaternion) -> Float {
  square_length(q)
  |> float.square_root
  |> result.unwrap(0.0)
}

pub fn normalize(q: Quaternion) -> Quaternion {
  let square_length =
    vec3.square_length(q.imaginary) +. q.real *. q.real
    |> float.square_root
    |> result.unwrap(0.0)

  let inv_length = 1.0 /. square_length
  scale(q, inv_length)
}

/// Rotates a 3D vector using a quaternion.
pub fn rotate_vector(
  q: Quaternion,
  v: #(Float, Float, Float),
) -> #(Float, Float, Float) {
  let t =
    vec3.cross(q.imaginary, v)
    |> vec3.scale(2.0)
  v
  |> vec3.add(vec3.scale(t, q.real))
  |> vec3.add(vec3.cross(q.imaginary, t))
}

/// Constructs the quaternion representing the rotation from v to w
/// 
/// https://stackoverflow.com/questions/1171849/finding-quaternion-representing-the-rotation-from-one-vector-to-another
/// 
/// Quaternion get_rotation_between(Vector3 u, Vector3 v)
// {
//   float k_cos_theta = dot(u, v);
//   float k = sqrt(length_2(u) * length_2(v));

//   if (k_cos_theta / k == -1)
//   {
//     // 180 degree rotation around any orthogonal vector
//     return Quaternion(0, normalized(orthogonal(u)));
//   }

//   return normalized(Quaternion(k_cos_theta + k, cross(u, v)));
// }
pub fn rotation_from_to(
  v: #(Float, Float, Float),
  w: #(Float, Float, Float),
) -> Quaternion {
  let k_cos_theta = vec3.dot(v, w)
  let k =
    float.square_root(vec3.square_length(v) *. vec3.square_length(w))
    |> result.unwrap(1.0)

  case k_cos_theta /. k == -1.0 {
    True -> Quaternion(0.0, vec3.normalize(vec3.orthogonal(v)))
    _ -> normalize(Quaternion(k_cos_theta +. k, vec3.cross(v, w)))
  }
}

/// Constructs the quaternion representing the given euler angle rotations (in radian)
pub fn euler_angles(x: Float, y: Float, z: Float) -> Quaternion {
  let cos_x_2 = elementary.cos(x /. 2.0)
  let cos_y_2 = elementary.cos(y /. 2.0)
  let cos_z_2 = elementary.cos(z /. 2.0)

  let sin_x_2 = elementary.sin(x /. 2.0)
  let sin_y_2 = elementary.sin(y /. 2.0)
  let sin_z_2 = elementary.sin(z /. 2.0)

  Quaternion(cos_x_2 *. cos_y_2 *. cos_z_2 +. sin_x_2 *. sin_y_2 *. sin_z_2, #(
    sin_x_2 *. cos_y_2 *. cos_z_2 -. cos_x_2 *. sin_y_2 *. sin_z_2,
    cos_x_2 *. sin_y_2 *. cos_z_2 +. sin_x_2 *. cos_y_2 *. sin_z_2,
    cos_x_2 *. cos_y_2 *. sin_z_2 -. sin_x_2 *. sin_y_2 *. cos_z_2,
  ))
}

/// Constructs a quaternion representing the given angle (in radians) around the given axis
pub fn axis_angle(axis: #(Float, Float, Float), angle: Float) -> Quaternion {
  Quaternion(
    elementary.cos(angle /. 2.0),
    axis
      |> vec3.scale(1.0 /. vec3.length(axis))
      |> vec3.scale(elementary.sin(angle /. 2.0)),
  )
}

pub fn loosely_equals(q: Quaternion, r: Quaternion, epsilon: Float) -> Bool {
  float.loosely_equals(q.real, r.real, epsilon)
  && float.loosely_equals(q.imaginary.0, r.imaginary.0, epsilon)
  && float.loosely_equals(q.imaginary.1, r.imaginary.1, epsilon)
  && float.loosely_equals(q.imaginary.2, r.imaginary.2, epsilon)
}

pub fn from_real(r: Float) -> Quaternion {
  Quaternion(r, #(0.0, 0.0, 0.0))
}

pub fn from_imaginary(i: #(Float, Float, Float)) -> Quaternion {
  Quaternion(0.0, i)
}

pub fn main() {
  io.println("Hello from quaternion!")
}
