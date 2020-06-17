module textures

struct ModelTexture {
pub:
	texture_id u32
}

pub fn create_model_texture(texture_id u32) &ModelTexture {
	return &ModelTexture{
		texture_id: texture_id
	}
}
