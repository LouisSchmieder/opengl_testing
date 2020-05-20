module maths

import glm
import math
import entities

pub fn create_transformation_matrix(translation glm.Vec3, rx, ry, rz, scale f32) glm.Mat4 {
	mut matrix := glm.identity()
	matrix = glm.translate(matrix, translation)
	matrix = glm.rotate(f32(math.radians(rx)), glm.vec3(1, 0, 0), matrix)
	matrix = glm.rotate(f32(math.radians(f64(ry))), glm.vec3(0, 1, 0), matrix)
	matrix = glm.rotate(f32(math.radians(f64(rz))), glm.vec3(0, 0, 1), matrix)
	matrix = glm.scale(matrix, glm.vec3(scale, scale, scale))
	return matrix
}

pub fn create_view_matrix(camera entities.Camera) glm.Mat4 {
	mut matrix := glm.identity()
	matrix = glm.rotate(f32(math.radians(camera.pitch)), glm.vec3(1, 0, 0), matrix)
	matrix = glm.rotate(f32(math.radians(camera.yaw)), glm.vec3(0, 1, 0), matrix)
	negavite_pos := camera.to_neg_position()
	matrix = glm.translate(matrix, negavite_pos)
	return matrix
}