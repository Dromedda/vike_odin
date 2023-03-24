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

player : Player
player2 : Player

SceneMainInit :: proc () {
	log("SCENE MAIN LOADING")
	PlayerInit(&player, 0, 0)
	PlayerInit(&player2, 96, 0)
	player.name = "player1"
	player2.name = "player2"
	vAddEntityToScene(&player, &SceneMain)
	vAddEntityToScene(&player2, &SceneMain)
}

SceneMainUpdate :: proc () {
	PlayerUpdate(&player)
	PlayerUpdate(&player2)
}

SceneMainDraw :: proc () {
	r.ClearBackground(r.LIGHTGRAY)
	r.DrawRectangleGradientV(0, 0, game.width, game.height, r.SKYBLUE, r.DARKPURPLE)
	r.DrawText("MAIN SCENE", 8, 48, 32, r.DARKGRAY)
	PlayerDraw(&player)
	PlayerDraw(&player2)
}

SceneMainEnd :: proc () {
	log("CLOSING MAIN SCENE")
	PlayerEnd(&player)
	PlayerEnd(&player2)
}

