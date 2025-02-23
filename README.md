# QUATERNION

A simple quaternion implementation made with and for *Gleam*. Heavily inspired by the *Rust* [quaternion](https://github.com/PistonDevelopers/quaternion) crate.

## Installation

```bash
gleam add quaternion
```

## Documentation

The online documentation is available [here](https://hexdocs.pm/quaternion/).

## Examples

#### Construct a quaternion:

```gleam
import gleam/io
import gleam_community/maths/elementary
import quaternion.{type Quaternion, Quaternion}

pub fn main() {
  // from the constructor
  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))

  // from a list
  let r = quaternion.from_list([0.5, -2.0, 3.0, 4.0])
  let l = quaternion.to_list(r)

  // from euler angles
  let s = quaternion.euler_angles(0.0, elementary.pi(), 0.0)

  // from a rotation around an axis 
  let axis = #(1.0, 1.0, 1.0) 
  let angle = elementary.pi()
  let t = quaternion.axis_angle(axis, angle)

  io.println(quaternion.to_string(q))
  // "1.0 + 2.0i + 3.0j + 4.0k"
}
```

### Algebra on quaternions

```gleam
  // [...]

  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let r = quaternion.from_list([0.5, -2.0, 3.0, 4.0])

  let sum = quaternion.add(q, r)
  let diff = quaternion.substract(q, r)
  let mult = quaternion.multiply(q, r)
  let scale = quaternion.scale(q, 3.0)

  let squared_length = quaternion.square_length(q)
  let length = quaternion.length(q)
  let norm = quaternion.normalize(q)

  let component_mult = quaternion.times(q, r)
  let dot_prod = quaternion.dot(q, r)

// [...]
```

### Rotation

```gleam
  // [...]

  let q = quaternion.euler_angles(0.0, elementary.pi(), 0.0)
  let v = #(1.0, 2.0, 3.0)

  let rot_v = quaternion.rotate_vector(q, v)

  // [...]
```

### Comparison

```gleam
  // [...]
  let epsilon = 0.0000001

  let q = Quaternion(1.0, #(2.0, 3.0, 4.0))
  let r = Quaternion(1.1, #(-2.2, 3.3, -4.4))
  let res = Quaternion(2.1, #(-0.2, 6.3, -0.4))
  q
  |> quaternion.add(r)
  |> quaternion.loosely_equals(res, epsilon)
  |> should.be_true

  // [...]
```

## License

Licensed under either of:

Apache License, Version 2.0, (LICENSE-APACHE or http://www.apache.org/licenses/LICENSE-2.0)
MIT license (LICENSE-MIT or http://opensource.org/licenses/MIT)
at your option.

## Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.
