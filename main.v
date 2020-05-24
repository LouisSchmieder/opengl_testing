module main

import renderengine
import shaders
import textures
import models
import entities

fn main() {
	display := renderengine.create_display(1280, 720, 60, 'Test')
	loader := models.create_loader()
	shader := shaders.create_shader('shaders/shader.vert', 'shaders/shader.frag')
	renderer := renderengine.create_renderer(70, .1, 1000, display, shader)


	model := models.load_obj_model('res/Wolf_One_obj.obj', loader)
	texture := textures.create_model_texture(loader.load_texture('res/textures/Wolf_Body.jpg'))
	textured_model := models.create_textured_model(model, texture)
	entity := entities.create_entity(textured_model, [f32(.0), f32(.0), f32(-50)], 0, 0, 0,
		10)
	camera := entities.create_camera([f32(.0), f32(.0), f32(.0)], 0, 0, 0)

	for !display.should_close() {
		entity.rotate(0, .02, 0)
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
