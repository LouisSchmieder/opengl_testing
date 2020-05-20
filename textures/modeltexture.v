module textures

struct ModelTexture {
pub:
	texture_id int
}

pub fn create_model_texture(texture_id int) &ModelTexture {
	return &ModelTexture{
		texture_id: texture_id
	}
}