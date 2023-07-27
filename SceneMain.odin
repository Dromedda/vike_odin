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
floor : Entity 
camera : r.Camera2D	

SceneMainInit :: proc () {
	log("SCENE MAIN LOADING")
	player.name = "player"
	PlayerInit(&player, 0, 0)

	floor.name = "floor"
	floor.x, floor.y = 200, 400
	floor.w, floor.h = 400, 64 
	floor.sclx, floor.scly = 1, 1
	floor.sprite = vCreateSprite("./Assets/tile.png", 400, 200, 0, 0)

	vAddEntityToScene(floor, &SceneMain)
	vAddEntityToScene(player, &SceneMain)

	camera.zoom = 0.5
	camera.offset = r.Vector2{f32(game.width/2), f32(game.height/2)}
}

SceneMainUpdate :: proc () {
	PlayerUpdate(&player)

	if vCheckMeetingE(&player, &floor) {
		vDebugLog("Touching Floor")
	}

	if (game.debug) {
		if vkeyp(r.KeyboardKey.Q) { camera.zoom = camera.zoom - 0.1; }
		if vkeyp(r.KeyboardKey.E) { camera.zoom = camera.zoom + 0.1; }
	}

	camera.target = r.Vector2{f32(player.x), f32(player.y)}
}

SceneMainDraw :: proc () {
	r.ClearBackground(r.LIGHTGRAY)
	r.DrawRectangleGradientV(0, 0, game.width, game.height, r.SKYBLUE, r.DARKPURPLE)

	r.BeginMode2D(camera)

	PlayerDraw(&player)
	r.DrawTexture(floor.sprite.texture, floor.x, floor.y, r.WHITE)

	r.EndMode2D()
}

SceneMainEnd :: proc () {
	log("CLOSING MAIN SCENE")
	vUnloadTexture2d(floor.sprite.texture)
	PlayerEnd(&player)
}

