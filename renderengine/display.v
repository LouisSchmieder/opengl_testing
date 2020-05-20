module renderengine

import glfw
import gl
import time

struct Display {
pub:
	window &glfw.Window
	keyboard &Keyboard
	fps int
mut:
	close bool
}

pub fn create_display(width, height, fps int, title string) &Display {
	glfw.init_glfw()
	keyboard := create_keyboard()
	window := glfw.create_window(glfw.WinCfg{
		width: width
		height: height
		title: title
		ptr: keyboard
	})
	window.make_context_current()
	window.on_resize(resize)
	window.onkeydown(keydown)
	gl.init_glad()
	gl.viewport(0, 0, width, height)
	return &Display{
		window: window
		fps: fps
		close: false
		keyboard: keyboard
	}
}

pub fn (mut display Display) update() {
	display.window.swap_buffers()
	if display.window.should_close() {
		display.close = true
	}
	time.sleep_ms(1000 / display.fps)
	glfw.poll_events()
}

pub fn (display Display) close() {
	display.window.destroy()
}

pub fn (display Display) should_close() bool {
	return display.close
}

fn resize(wnd voidptr, width, height int) {
	gl.viewport(0, 0, width, height)	
}

fn keydown(wnd voidptr, key, scancode, action, mods int) {
	keyboard := &Keyboard(glfw.get_window_user_pointer(wnd))
	mut press := false
	if action != C.GLFW_RELEASE {
		press = true
	}
	keyboard.button_action(press, key)
}