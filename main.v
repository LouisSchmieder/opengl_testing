module main

import renderengine
import shaders
import textures
import models
import entities

fn main() {
	display := renderengine.create_display(1280, 720, 60, 'Test')
	loader := renderengine.create_loader()
	shader := shaders.create_shader('shaders/shader.vert', 'shaders/shader.frag')
	renderer := renderengine.create_renderer(70, .1, 1000, display, shader)
	verticies := [
		f32(-.5), f32(.5), f32(-.5),
		f32(-.5), f32(-.5), f32(-.5),
		f32(.5), f32(-.5), f32(-.5),
		f32(.5), f32(.5), f32(-.5),
		f32(-.5), f32(.5), f32(.5),
		f32(-.5), f32(-.5), f32(.5),
		f32(.5), f32(-.5), f32(.5),
		f32(.5), f32(.5), f32(.5),
		f32(.5), f32(.5), f32(-.5),
		f32(.5), f32(-.5), f32(-.5),
		f32(.5), f32(-.5), f32(.5),
		f32(.5), f32(.5), f32(.5),
		f32(-.5), f32(.5), f32(-.5),
		f32(-.5), f32(-.5), f32(-.5),
		f32(-.5), f32(-.5), f32(.5),
		f32(-.5), f32(.5), f32(.5),
		f32(-.5), f32(.5), f32(.5),
		f32(-.5), f32(.5), f32(-.5),
		f32(.5), f32(.5), f32(-.5),
		f32(.5), f32(.5), f32(.5),
		f32(-.5), f32(-.5), f32(.5),
		f32(-.5), f32(-.5), f32(-.5),
		f32(.5), f32(-.5), f32(-.5),
		f32(.5), f32(-.5), f32(.5)
	]

	incidices := [
		0, 1, 3,
		3, 1, 2,
		4, 5, 7,
		7, 5, 6,
		8, 9, 11,
		11, 9, 10,
		12, 13, 15,
		15, 13, 14,
		16, 17, 19,
		19, 17, 18,
		20, 21, 23,
		23, 21, 22
	]

	texture_coords := [
		f32(0), f32(0),
		f32(0), f32(1),
		f32(1), f32(1),
		f32(1), f32(0),
		f32(0), f32(0),
		f32(0), f32(1),
		f32(1), f32(1),
		f32(1), f32(0),
		f32(0), f32(0),
		f32(0), f32(1),
		f32(1), f32(1),
		f32(1), f32(0),
		f32(0), f32(0),
		f32(0), f32(1),
		f32(1), f32(1),
		f32(1), f32(0),
		f32(0), f32(0),
		f32(0), f32(1),
		f32(1), f32(1),
		f32(1), f32(0),
		f32(0), f32(0),
		f32(0), f32(1),
		f32(1), f32(1),
		f32(1), f32(0)
	]

	model := loader.load_to_vao(verticies, texture_coords, incidices)
	texture := textures.create_model_texture(loader.load_texture('res/texture.png'))
	textured_model := models.create_textured_model(model, texture)
	entity := entities.create_entity(textured_model, [f32(.0), f32(.0), f32(-5)], 0, 0, 0,
		1)
	camera := entities.create_camera([f32(.0), f32(.0), f32(.0)], 0, 0, 0)

	for !display.should_close() {
		entity.rotate(1, 1, 0)
		camera.move(display.keyboard.keys)
		renderer.clear()
		shader.start()
		shader.load_view_matrix(camera)
		renderer.render(entity)
		shader.stop()
		display.update()
	}
	shader.clean_up()
	loader.clean_up()
	display.close()
}
