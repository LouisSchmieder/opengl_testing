module models

import os

struct Vertex {
	x f32
	y f32
	z f32
}

struct Texture {
	x f32
	y f32
}

struct Normal {
	x f32
	y f32
	z f32
}

pub fn load_obj_model(file string, loader Loader) RawModel {
	data := os.read_file(file) or { panic(err) }
	mut verticies := []Vertex{}
	mut textures := []Texture{}
	mut normals := []Normal{}
	mut indicies := []int{}

	mut a_textures := []f32{}
	mut a_normals := [] f32{}
	lines := data.split('\n')
	mut f := false
	for line in lines {
		c_line := line.split(' ')
		if line.starts_with('v ') {
			verticies << Vertex{c_line[1].f32(), c_line[2].f32(), c_line[2].f32()}
		} else if line.starts_with('vt ') {
			textures << Texture{c_line[1].f32(), c_line[2].f32()}
		} else if line.starts_with('vn ') {
			normals << Normal{c_line[1].f32(), c_line[2].f32(), c_line[2].f32()}
		} else if line.starts_with('f ') {
			if !f {
				a_textures = []f32{len: verticies.len * 2}
				a_normals = []f32{len: verticies.len * 3}
			}
			v1 := c_line[1].split('/')
			v2 := c_line[2].split('/')
			v3 := c_line[3].split('/')

			mut i, mut t, mut n := process_vertex(v1, indicies, verticies, textures, normals, a_textures, a_normals)
			indicies = i
			a_textures = t
			a_normals = n
			i, t, n = process_vertex(v2, indicies, verticies, textures, normals, a_textures, a_normals)
			indicies = i
			a_textures = t
			a_normals = n
			i, t, n = process_vertex(v3, indicies, verticies, textures, normals, a_textures, a_normals)
			indicies = i
			a_textures = t
			a_normals = n
		}
	}

	mut a_verticies := []f32{len: verticies.len * 3}
	mut v_p := 0

	for vertex in verticies {
		a_verticies[v_p] = vertex.x
		a_verticies[v_p + 1] = vertex.y
		a_verticies[v_p + 2] = vertex.z
		v_p += 3
	}

	return loader.load_to_vao(a_verticies, a_textures, indicies)
}

fn process_vertex(vertex_data []string, i []int, verticies []Vertex, textures []Texture, normals []Normal, t []f32, n []f32) ([]int, []f32, []f32) {
	mut indicies := i
	mut a_textures := t
	mut a_normals := n

	current_vertex := vertex_data[0].int() - 1
	indicies << current_vertex
	curr_tex := textures[vertex_data[1].int() - 1]
	a_textures[current_vertex * 2] = curr_tex.x
	a_textures[current_vertex * 2 + 1] = 1 - curr_tex.y

	curr_normal := normals[vertex_data[2].int() - 1]
	a_normals[current_vertex * 3] = curr_normal.x
	a_normals[current_vertex * 3 + 1] = curr_normal.y
	a_normals[current_vertex * 3 + 2] = curr_normal.z

	return indicies, a_textures, a_normals
}