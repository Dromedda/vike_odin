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
floor : Tile

// camera : r.Camera2D	

SceneMainInit :: proc () {
	log("SCENE MAIN LOADING")

	PlayerInit(&player, 0, 0)
	floor.w = 400
	floor.h = 64
	floor.x = 200
	floor.y =  400
	floor.texture = vLoadTexture2d("./Assets/tile.png")
	player.name = "player1"
	vAddEntityToScene(&player, &SceneMain)

	// camera.zoom = 0
	// camera.offset = r.Vector2{f32(game.width/2), f32(game.height/2)}

}

SceneMainUpdate :: proc () {
	PlayerUpdate(&player)
	if vCheckMeetingT(&player, &floor) {
		log("Touching Floor")
	}

	// camera.target = r.Vector2{f32(player.x), f32(player.y)}
}

SceneMainDraw :: proc () {
	r.ClearBackground(r.LIGHTGRAY)
	r.DrawRectangleGradientV(0, 0, game.width, game.height, r.SKYBLUE, r.DARKPURPLE)
	r.DrawText("MAIN SCENE", 1, 1, 2, r.DARKGRAY)

	// r.BeginMode2D(camera)

	PlayerDraw(&player)
	r.DrawTexture(floor.texture, floor.x, floor.y, r.WHITE)

	// r.EndMode2D()
}

SceneMainEnd :: proc () {
	log("CLOSING MAIN SCENE")
	PlayerEnd(&player)
}

