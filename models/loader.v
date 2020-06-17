module models

import gl
import stbi

struct Loader {
mut:
	vaos []u32
	vbos []u32
	textures []u32
}

pub fn create_loader() &Loader {
	return &Loader{
		vaos: []u32{}
		vbos: []u32{}
		textures: []u32{}
	}
}

pub fn (mut loader Loader) load_to_vao(positions, texture_coords []f32, indicies []int) RawModel {
	vao_id := loader.create_vao()
	loader.bind_indicies_buffer(indicies)
	loader.store_data_in_attrib_list(0, 3, positions)
	loader.store_data_in_attrib_list(1, 2, texture_coords)
	loader.unbind_vao()
	return create_raw_model(vao_id, indicies.len)
}

pub fn (mut loader Loader) load_texture(path string) u32 {
	texture := gl.gen_texture()
	loader.textures << texture
	img := stbi.load(path)
	gl.bind_2d_texture(texture)
	img.tex_image_2d()
	gl.generate_mipmap(C.GL_TEXTURE_2D)
	img.free()
	return texture
}

pub fn (loader Loader) clean_up() {
	for vao in loader.vaos {
		gl.delete_vao(vao)
	}
	for vbo in loader.vbos {
		gl.delete_buffer(vbo)
	}
	for texture in loader.textures {
		gl.delete_texture(texture)
	}
}

fn (mut loader Loader) create_vao() u32 {
	vao_id := gl.gen_vertex_array()
	loader.vaos << vao_id
	gl.bind_vao(vao_id)
	return vao_id
}

fn (mut loader Loader) store_data_in_attrib_list(attrib_number, size int, data []f32) {
	vbo_id := gl.gen_buffer()
	loader.vbos << vbo_id
	gl.set_vbo(vbo_id, data, C.GL_STATIC_DRAW)
	gl.vertex_attrib_pointer(attrib_number, size, C.GL_FLOAT, false, 0, 0)
	gl.bind_buffer(C.GL_ARRAY_BUFFER, 0)
}

fn (loader Loader) unbind_vao() {
	gl.bind_vao(0)
}

fn (mut loader Loader) bind_indicies_buffer(indicies []int) {
	vbo_id := gl.gen_buffer()
	loader.vbos << vbo_id
	gl.set_ebo(vbo_id, indicies, C.GL_STATIC_DRAW)
}
