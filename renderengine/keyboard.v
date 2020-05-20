module renderengine

//keys[keycode] = clicked
struct Keyboard {
pub mut:
	keys []bool
}

pub fn create_keyboard() &Keyboard {
	return &Keyboard{
		keys: []bool{len: 256, cap: 256}
	}
}

pub fn (mut keyboard Keyboard) button_action(push bool, keycode int) {
	if keyboard.keys[keycode] != push {
		keyboard.keys[keycode] = push
	}
}