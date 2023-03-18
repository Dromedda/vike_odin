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

@(private="file")
bob : Texture

// -- MAIN SCENE -- // 
SceneMainInit :: proc () {
	log("SCENE MAIN LOADED")
	bob = vLoadTexture2d("./Assets/bob.png")
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

	// Simple way to draw 2d texture
	vDrawTexture2d(bob, player.x + 32, player.y + 32, r.LIME)

	// the advanced way to draw 2d textures
	// Source is the "crop" of the original image we want to draw
	// Destination is where we want to draw the "crop" of the image
	// origin is where on the image we want to set as "0, 0" of said "crop"
	bob_source : r.Rectangle = {0, 0, f32(bob.texture.width), f32(bob.texture.height)}
	bob_dest   : r.Rectangle = {0, 0, f32(bob.texture.width), f32(bob.texture.height)}
	bob_origin : r.Vector2   = {0, 0}
	vDrawTexture2dPro(bob, bob_source, bob_dest, bob_origin, 0, r.RED)
}

SceneMainEnd :: proc () {
	vUnloadTexture2d(bob)
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
