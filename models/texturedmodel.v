module models

import textures

struct TexturedModel {
pub:
	raw_model RawModel
	texture textures.ModelTexture
}

pub fn create_textured_model(model RawModel, texture textures.ModelTexture) &TexturedModel {
	return &TexturedModel{
		raw_model: model
		texture: texture
	}
}