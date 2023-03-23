package main

import r "vendor:raylib"
import f "core:fmt"

game:Game = {
	width = 900,
	height = 600,
	debug = true,
}

main :: proc() {
	r.InitWindow(game.width, game.height, "VIKE")
	r.SetTargetFPS(60)
	defer r.CloseWindow() // Defer defers the call to the end of the scope

	vAddScene(SceneMain)
	vAddScene(SceneTest)

	vGameInit()
	defer vGameEnd()

	for !r.WindowShouldClose() {
		vGameUpdate()
		CheckDebugToggle()
		r.BeginDrawing()
			vGameDraw()

			if (game.debug) {
				r.DrawFPS(8,8)
			}

		r.EndDrawing()
	}
}

CheckDebugToggle :: proc() {
	if vkeyp(r.KeyboardKey.F5) {
		game.debug = !game.debug
	}
}
