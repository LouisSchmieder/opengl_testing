module shaders

import os
import gl
import glm
import entities
import maths

struct Shader {
	program_id int
	vertex_shader_id int
	fragment_shader_id int
mut:
	loc_trans_matrix int
	loc_proj_matrix int
	loc_view_matrix int
}


pub fn create_shader(vertex_path, fragment_path string) &Shader {
	vertex_shader_id := load_shader(vertex_path, C.GL_VERTEX_SHADER)
	fragment_shader_id := load_shader(fragment_path, C.GL_FRAGMENT_SHADER)
	program_id := gl.create_program()

	shader := &Shader{
		program_id: program_id
		vertex_shader_id: vertex_shader_id
		fragment_shader_id: fragment_shader_id
	}

	gl.attach_shader(program_id, vertex_shader_id)
	gl.attach_shader(program_id, fragment_shader_id)
	shader.bind_attributes()
	gl.link_program(program_id)
	gl.validate_program(program_id)

	shader.get_all_uniform_locations()

	return shader
}

fn (mut shader Shader) get_all_uniform_locations() {
	shader.loc_trans_matrix = shader.get_uniform_location('transformationMatrix')
	shader.loc_proj_matrix = shader.get_uniform_location('projectionMatrix')
	shader.loc_view_matrix = shader.get_uniform_location('viewMatrix')
}

fn (shader Shader) get_uniform_location(name string) int {
	return gl.get_uniform_location(shader.program_id, name)
}

pub fn (shader Shader) load_transformation_matrix(matrix glm.Mat4) {
	shader.load_matrix(shader.loc_trans_matrix, matrix)
}

pub fn (shader Shader) load_projection_matrix(matrix glm.Mat4) {
	shader.load_matrix(shader.loc_proj_matrix, matrix)
}

pub fn (shader Shader) load_view_matrix(camera entities.Camera) {
	matrix := maths.create_view_matrix(camera)
	shader.load_matrix(shader.loc_view_matrix, matrix)
}

pub fn (shader Shader) start() {
	gl.use_program(shader.program_id)
}

pub fn (shader Shader) stop() {
	gl.use_program(0)
}

pub fn (shader Shader) clean_up() {
	shader.stop()
	gl.detach_shader(shader.program_id, shader.vertex_shader_id)
	gl.detach_shader(shader.program_id, shader.fragment_shader_id)
	gl.delete_shader(shader.vertex_shader_id)
	gl.delete_shader(shader.fragment_shader_id)
	gl.delete_program(shader.program_id)
} 

fn (shader Shader) bind_attributes() {
	shader.bind_attribute(0, 'position')
	shader.bind_attribute(1, 'textureCoords')
}

fn (shader Shader) bind_attribute(attribute int, name string) {
	gl.bind_attrib_location(shader.program_id, attribute, name)
}

fn (shader Shader) load_float(loc int, val f32) {
	gl.set_f32(loc, val)	
}

fn (shader Shader) load_vec(loc int, vec []f32) {
	gl.set_vec(loc, vec[0], vec[1], vec[2])
}

fn (shader Shader) load_bool(loc int, val bool) {
	gl.set_bool(loc, val)
}

fn (shader Shader) load_matrix(loc int, val glm.Mat4) {
	gl.set_mat4fv(loc, 1, false, val)
}

pub fn load_shader(file string, typ int) int {
	src := os.read_file(file) or { panic(err) }
	shader_id := gl.create_shader(typ)
	gl.shader_source(shader_id, 1, src, 0)
	gl.compile_shader(shader_id)
	if gl.shader_compile_status(shader_id) == 0 {
		cerror := gl.shader_info_log(shader_id)
		eprintln('failed to compile, with error')
		eprintln(cerror)
		exit(1)
	}
	return shader_id
}