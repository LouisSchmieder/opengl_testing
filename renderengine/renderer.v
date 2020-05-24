module renderengine

import gl
import glm
import entities
import shaders
import maths
import math

struct Renderer {
	fov f32
	near_plane f32
	far_plane f32
	display &Display
	shader &shaders.Shader
mut:
	projection_matrix glm.Mat4
}

pub fn create_renderer(fov, near_plane, far_plane f32, display &Display, shader &shaders.Shader) &Renderer {
	renderer := &Renderer{
		fov: fov
		near_plane: near_plane
		far_plane: far_plane
		display: display
		shader: shader
	}

	renderer.create_projection_matrix()
	shader.start()
	shader.load_projection_matrix(renderer.projection_matrix)
	shader.stop()

	return renderer
}

pub fn (renderer Renderer) clear() {
	gl.enable(C.GL_DEPTH_TEST)
	C.glClear(C.GL_COLOR_BUFFER_BIT | C.GL_DEPTH_BUFFER_BIT)
	gl.clear_color(255, 255, 255, 255)
}

pub fn (renderer Renderer) render(entity entities.Entity) {
	textured_model := entity.model
	model := textured_model.raw_model
	gl.bind_vao(model.vao_id)
	gl.enable_vertex_attrib_array(0)
	gl.enable_vertex_attrib_array(1)
	transformation_matrix := maths.create_transformation_matrix(entity.to_position(), entity.rot_x, entity.rot_y, entity.rot_z, entity.scale)
	renderer.shader.load_transformation_matrix(transformation_matrix)

	gl.draw_elements(C.GL_LINES, model.vertex_count, C.GL_UNSIGNED_INT, 0)
	gl.disable_vertex_attrib_array(0)
	gl.disable_vertex_attrib_array(1)
	gl.bind_vao(0)
}

fn (mut renderer Renderer) create_projection_matrix() {
	size := renderer.display.window.get_window_size()
	aspec_ratio := f32(size.width) / f32(size.height)
	y_scale := ((f32(1) / math.tan(math.radians(renderer.fov / 2))) * aspec_ratio)
	x_scale := y_scale / aspec_ratio
	frustum_len := renderer.far_plane - renderer.near_plane

	matrix := glm.identity()
	mut data := matrix.data
	data[0] = x_scale
	data[5] = y_scale
	data[10] = -((renderer.far_plane + renderer.near_plane) / frustum_len)
	data[11] = -1
	data[14] = -((2 * renderer.near_plane * renderer.far_plane) / frustum_len)
	data[15] = 0

	result := glm.Mat4{
		data: data
	}

	renderer.projection_matrix = result
}