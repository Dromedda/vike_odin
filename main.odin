package main

import r "vendor:raylib"
import f "core:fmt"

game:Game = {
	width = 1280,
	height = 720,
	debug = false,
}

scenes : []^Scene = { 
	&SceneMain,
}

main :: proc() {
	r.InitWindow(game.width, game.height, "VIKE")
	r.SetWindowPosition(0, 0) // we do this, otherwise it ends up in the middle ! THIS IS LOCAL TO ME !

	r.SetTargetFPS(60)
	defer r.CloseWindow() // Defer defers the call to the end of the scope
	vAddScene(&SceneMain) 
	vGameInit()
	defer vGameEnd()

	for !r.WindowShouldClose() {
		vGameUpdate()
		CheckDebugToggle()

		r.BeginDrawing()
			vGameDraw()
			if game.debug { vDebugDrawLog() }
		r.EndDrawing()

		if (r.IsWindowResized()) {
			vAutoAdjustWindow(&game.camera)
		}
	}
}

CheckDebugToggle :: proc() {
	if vkeyp(r.KeyboardKey.F5) { game.debug = !game.debug }
	if (!game.debug) { return }
	if vkeyp(r.KeyboardKey.F6) { vDebugLogClear() }
}
