package main
import r "vendor:raylib"
import f "core:fmt"

SceneMain : Scene = {
	id = "main",
	init = proc() {
		log("SCENE MAIN LOADED")
		player.init(&player)
	},

	update = proc() {
		player.update(&player)
		if (vkeyr(r.KeyboardKey.F1)) {
			vGotoScene("test")
		}
	},

	draw = proc() {
		r.ClearBackground(r.LIGHTGRAY)
		r.DrawText("Hello From Vike!", i32(window_w / 4), i32(window_h/4), 32, r.DARKGRAY)
		player.draw(&player)
	},

	end = proc() {
		log("CLOSING MAIN SCENE")
	},
}

SceneTest : Scene = {
	id = "test",
	init = proc() {
		log("SCENE TEST LOADED")
	},
	update = proc() {
		if (vkeyr(r.KeyboardKey.F1)) {
			vGotoScene("main")
		}
	},
	draw = proc() {
		r.ClearBackground(r.LIGHTGRAY)
	},
	end = proc() {
		log("CLOSING TEST SCENE")
	},
}
