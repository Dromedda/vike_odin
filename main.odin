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
	game.scenes[0] = SceneMain
	game.scenes[1] = SceneTest

	ww := cast(i32) window_w
	wh := cast(i32) window_h	
	r.InitWindow(ww, wh, "VIKE")
	r.SetTargetFPS(60)
	game.activeScene.init()
	for !r.WindowShouldClose() {
		game.activeScene.update()
		r.BeginDrawing()
			game.activeScene.draw()
		r.EndDrawing()
	}
	game.activeScene.end()
}

