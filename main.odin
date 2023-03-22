package main
import r "vendor:raylib"
import f "core:fmt"

// TODO: Figure out Arrays in ODIN 
game:Game = {
	activeScene = SceneMain,
	width = 900,
	height = 600,
}

main::proc() {
	// Add the scenes
	game.scenes[0] = SceneMain
	game.scenes[1] = SceneTest

	// do some inits for the window
	r.InitWindow(game.width, game.height, "VIKE")
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

