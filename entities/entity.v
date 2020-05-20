module entities

import models
import glm

struct Entity {
pub mut:
	model models.TexturedModel
	position []f32
	rot_x f32
	rot_y f32
	rot_z f32
	scale f32
}

pub fn create_entity(model models.TexturedModel, position []f32, rot_x, rot_y, rot_z, scale f32) &Entity {
	return &Entity{
		model: model
		position: position
		rot_x: rot_x
		rot_y: rot_y
		rot_z: rot_z
		scale: scale
	}
}

pub fn (mut entity Entity) move(dx, dy, dz f32) {
	entity.position[0] += dx
	entity.position[1] += dy
	entity.position[2] += dz
}

pub fn (mut entity Entity) rotate(dx, dy, dz f32) {
	entity.rot_x += dx
	entity.rot_y += dy
	entity.rot_z += dz
}

pub fn (entity Entity) to_position() glm.Vec3 {
	return glm.vec3(entity.position[0], entity.position[1], entity.position[2])
}