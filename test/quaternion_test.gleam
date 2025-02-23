import gleam_community/maths/elementary
import gleeunit
import gleeunit/should
import quaternion.{type Quaternion, Quaternion}
import vec3

pub fn main() {
  gleeunit.main()
}

const epsilon = 0.001

pub fn from_list_test() {
  [1.0, 2.0, 3.0, 4.0]
  |> quaternion.from_list()
  |> should.equal(Ok(Quaternion(1.0, #(2.0, 3.0, 4.0))))
}

pub fn to_list_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.to_list()
  |> should.equal([1.0, 2.0, 3.0, 4.0])
}

pub fn to_string_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.to_string
  |> should.equal("1.0 + 2.0i + 3.0j + 4.0k")
}

pub fn add_test() {
  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let r = Quaternion(1.1, #(-2.2, 3.3, -4.4))
  let res = Quaternion(2.1, #(-0.2, 6.3, -0.4))
  q
  |> quaternion.add(r)
  |> quaternion.loosely_equals(res, epsilon)
  |> should.be_true
}

pub fn substract_test() {
  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let r = Quaternion(1.1, #(-2.2, 3.3, -4.4))
  let res = Quaternion(-0.1, #(4.2, -0.3, 8.4))
  q
  |> quaternion.substract(r)
  |> quaternion.loosely_equals(res, epsilon)
  |> should.be_true
}

pub fn times_test() {
  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let r = Quaternion(0.5, #(0.25, -1.0, 4.0))
  let res = Quaternion(0.5, #(0.5, -3.0, 16.0))
  q
  |> quaternion.times(r)
  |> quaternion.loosely_equals(res, epsilon)
  |> should.be_true
}

pub fn scale_test() {
  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let res = Quaternion(-0.5, #(-1.0, -1.5, -2.0))
  q
  |> quaternion.scale(-0.5)
  |> quaternion.loosely_equals(res, epsilon)
  |> should.be_true
}

pub fn dot_test() {
  let q = Quaternion(1.0, #(2.0, -2.0, -1.0))
  let r = Quaternion(-1.0, #(1.0, 2.0, -2.0))
  q
  |> quaternion.dot(r)
  |> should.equal(-1.0)
}

pub fn multiply_test() {
  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let r = Quaternion(1.0, #(-1.0, 2.0, -2.0))
  let res = Quaternion(5.0, #(-13.0, 5.0, 9.0))
  q
  |> quaternion.multiply(r)
  |> quaternion.loosely_equals(res, epsilon)
  |> should.be_true
}

pub fn conjugate_test() {
  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let q_conjugate = Quaternion(1.0, #(-2.0, -3.0, -4.0))
  q
  |> quaternion.conjugate()
  |> should.equal(q_conjugate)
}

pub fn square_length_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.square_length()
  |> should.equal(30.0)
}

pub fn rotate_vector_test() {
  let v = #(0.0, 1.0, 0.0)
  let v_parallel = #(1.0, 1.0, 1.0)
  let res = #(-1.0, 1.0, -1.0)
  v
  |> quaternion.axis_angle(elementary.pi())
  |> quaternion.rotate_vector(v_parallel)
  |> vec3.loosely_equals(res, epsilon)
  |> should.be_true
}

/// When vectors are parallel the output vector should be the same
pub fn rotate_vector_parallel_test() {
  let v = #(1.0, 1.0, 1.0)
  let w = v
  let res = #(1.0, 1.0, 1.0)
  v
  |> quaternion.axis_angle(32.12)
  |> quaternion.rotate_vector(w)
  |> vec3.loosely_equals(res, epsilon)
  |> should.be_true
}

pub fn euler_angles_test() {
  let q = quaternion.euler_angles(0.0, elementary.pi(), 0.0)
  let v = #(1.0, 1.0, 1.0)
  let res = #(-1.0, 1.0, -1.0)
  q
  |> quaternion.rotate_vector(v)
  |> vec3.loosely_equals(res, epsilon)
  |> should.be_true
}

pub fn axis_angle_test() {
  let v = #(1.0, 1.0, 1.0)
  let angle = elementary.pi()
  let res = Quaternion(0.0, #(0.577, 0.577, 0.577))
  v
  |> quaternion.axis_angle(angle)
  |> quaternion.loosely_equals(res, epsilon)
  |> should.be_true
}
