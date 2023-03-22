package main
import r "vendor:raylib"
import f "core:fmt"

game:Game = {
	width = 900,
	height = 600,
}

main::proc() {
	r.InitWindow(game.width, game.height, "VIKE")
	r.SetTargetFPS(60)
	defer r.CloseWindow()

	vAddScene(SceneMain)
	vAddScene(SceneTest)

	vGameInit()
	defer vGameEnd()


	for !r.WindowShouldClose() {
		vGameUpdate()

		r.BeginDrawing()
			r.DrawFPS(8,8)
			vGameDraw()
		r.EndDrawing()
	}

}

