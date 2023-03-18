package main
import r "vendor:raylib"
import f "core:fmt"

SceneMain : Scene = {
	id = "main",
	init = SceneMainInit,
	update = SceneMainUpdate,
	draw = SceneMainDraw,
	end = SceneMainEnd,
}

SceneTest : Scene = {
	id = "test",
	init = SceneTestInit,
	update = SceneTestUpdate,
	draw = SceneTestDraw,
	end = SceneTestEnd,
}

// -- MAIN SCENE -- // 
SceneMainInit :: proc () {
	log("SCENE MAIN LOADED")
	player.init(&player)
}

SceneMainUpdate :: proc () {
	player.update(&player)
	if (vkeyr(r.KeyboardKey.F1)) {
		vGotoScene("test")
	}
}

SceneMainDraw :: proc () {
	r.ClearBackground(r.LIGHTGRAY)
	r.DrawText("MAIN SCENE", 8, 48, 32, r.DARKGRAY)
	player.draw(&player)
}

SceneMainEnd :: proc () {
	log("CLOSING MAIN SCENE")
}


// -- TEST SCENE -- // 
SceneTestInit :: proc () {
	log("SCENE TEST LOADED")
}

SceneTestUpdate :: proc () {
	if (vkeyr(r.KeyboardKey.F1)) {
		vGotoScene("main")
	}
}

SceneTestDraw :: proc() {
	r.ClearBackground(r.LIGHTGRAY)
	r.DrawText("TEST SCENE", 8, 48, 32, r.DARKGRAY)
}

SceneTestEnd :: proc () {
	log("CLOSING TEST SCENE")
}
