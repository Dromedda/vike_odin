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
			if game.debug { 
				vDebugDrawLog() 
				for i := 0; i < len(game.activeScene.entities); i+=1 {
					e := game.activeScene.entities[i]	
					// TODO: Add an active camera to the game struct so that we can access it here in drawing
					//r.DrawRectangle(e.x, e.y, e.w, e.h, r.RED)	
				}
			}
		r.EndDrawing()
	}
}

CheckDebugToggle :: proc() {
	if vkeyp(r.KeyboardKey.F5) {
		game.debug = !game.debug
	}

	if vkeyp(r.KeyboardKey.F6) {
		vDebugLogClear()
	}
}
