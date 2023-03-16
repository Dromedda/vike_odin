package main
import r "vendor:raylib"
import f "core:fmt"

// TODO: Figure out Arrays in ODIN 
game:Game = {
	activeScene = SceneMain,
}

window_w := 900
window_h := 600

main::proc() {
	// Add the scenes
	game.scenes[0] = SceneMain
	game.scenes[1] = SceneTest

	// Create Some window dims and make them i32s
	ww := cast(i32) window_w
	wh := cast(i32) window_h	

	// do some inits for the window
	r.InitWindow(ww, wh, "VIKE")
	r.SetTargetFPS(60)
	game.activeScene.init()

	// Main Loop
	for !r.WindowShouldClose() {
		game.activeScene.update()

		// Draw calls go in here
		r.BeginDrawing()
			r.DrawFPS(8,8)
			game.activeScene.draw()
		r.EndDrawing()
	}

	// Close the window and context
	game.activeScene.end()
	r.CloseWindow()
}

