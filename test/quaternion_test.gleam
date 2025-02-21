import gleam/float
import gleam/result
import gleam_community/maths/elementary
import gleeunit
import gleeunit/should
import quaternion.{type Quaternion, Quaternion}

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
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.add(Quaternion(1.1, #(-2.2, 3.3, -4.4)))
  |> quaternion.loosely_equals(Quaternion(2.1, #(-0.2, 6.3, -0.4)), epsilon)
  |> should.equal(True)
}

pub fn substract_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.substract(Quaternion(1.1, #(-2.2, 3.3, -4.4)))
  |> quaternion.loosely_equals(Quaternion(-0.1, #(4.2, -0.3, 8.4)), epsilon)
  |> should.equal(True)
}

pub fn times_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.times(Quaternion(0.5, #(0.25, -1.0, 4.0)))
  |> quaternion.loosely_equals(Quaternion(0.5, #(0.5, -3.0, 16.0)), epsilon)
  |> should.equal(True)
}

pub fn scale_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.scale(-0.5)
  |> quaternion.loosely_equals(Quaternion(-0.5, #(-1.0, -1.5, -2.0)), epsilon)
  |> should.equal(True)
}

pub fn dot_test() {
  Quaternion(1.0, #(2.0, -2.0, -1.0))
  |> quaternion.dot(Quaternion(-1.0, #(1.0, 2.0, -2.0)))
  |> should.equal(-1.0)
}

pub fn multiply_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.multiply(Quaternion(1.0, #(-1.0, 2.0, -2.0)))
  |> quaternion.loosely_equals(Quaternion(5.0, #(-13.0, 5.0, 9.0)), epsilon)
  |> should.equal(True)
}

pub fn conjugate_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.conjugate()
  |> should.equal(Quaternion(1.0, #(-2.0, -3.0, -4.0)))
}

pub fn square_length_test() {
  Quaternion(1.0, #(2.0, 3.0, 4.0))
  |> quaternion.square_length()
  |> should.equal(30.0)
}

pub fn rotate_vector_test() {
  #(0.0, 1.0, 0.0)
  |> quaternion.axis_angle(elementary.pi())
  |> quaternion.rotate_vector(#(1.0, 1.0, 1.0))
  |> quaternion.from_imaginary
  |> quaternion.loosely_equals(Quaternion(0.0, #(-1.0, 1.0, -1.0)), epsilon)
  |> should.equal(True)
}

/// When vectors are parallel the output vector should be the same
pub fn rotate_vector_parallel_test() {
  #(1.0, 1.0, 1.0)
  |> quaternion.axis_angle(32.12)
  |> quaternion.rotate_vector(#(1.0, 1.0, 1.0))
  |> quaternion.from_imaginary
  |> quaternion.loosely_equals(Quaternion(0.0, #(1.0, 1.0, 1.0)), epsilon)
  |> should.equal(True)
}

pub fn rotation_from_to_1_test() {
  let a = #(1.0, 1.0, 1.0)
  let b = #(-1.0, -1.0, -1.0)
  let q = quaternion.rotation_from_to(a, b)

  quaternion.rotate_vector(q, a)
  |> quaternion.from_imaginary
  |> quaternion.loosely_equals(quaternion.from_imaginary(b), epsilon)
  |> should.equal(True)
}

pub fn rotation_from_to_2_test() {
  let a = #(1.0, 1.0, 0.0)
  let b = #(0.0, 1.0, 0.0)
  let q = quaternion.rotation_from_to(a, b)

  quaternion.rotate_vector(q, a)
  |> quaternion.from_imaginary
  |> quaternion.loosely_equals(quaternion.from_imaginary(b), epsilon)
  |> should.equal(True)
}

pub fn rotation_from_to_3_test() {
  let a = #(1.0, 0.0, 0.0)
  let b = #(0.0, -1.0, 0.0)
  let q = quaternion.rotation_from_to(a, b)

  quaternion.rotate_vector(q, a)
  |> quaternion.from_imaginary
  |> quaternion.loosely_equals(quaternion.from_imaginary(b), epsilon)
  |> should.equal(True)
}

pub fn euler_angles_test() {
  quaternion.euler_angles(0.0, elementary.pi(), 0.0)
  |> quaternion.rotate_vector(#(1.0, 1.0, 1.0))
  |> quaternion.from_imaginary
  |> quaternion.loosely_equals(Quaternion(0.0, #(-1.0, 1.0, -1.0)), epsilon)
  |> should.equal(True)
}

pub fn axis_angle_test() {
  #(1.0, 1.0, 1.0)
  |> quaternion.axis_angle(elementary.pi())
  |> quaternion.loosely_equals(Quaternion(0.0, #(0.577, 0.577, 0.577)), epsilon)
  |> should.equal(True)
}
