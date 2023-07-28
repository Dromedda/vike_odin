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

	player = vCreateEntity(Player, "player")
	vAddEntityToScene(player, &SceneMain)
	PlayerInit(&player, 0, 0)

	floor = vCreateEntity(Entity, "floor")
	{
		using floor // allows us to omit the "floor."
		x, y = 200, 400
		w, h = 400, 64
		sclx, scly = 1, 1
		sprite = vCreateSprite("./Assets/tile.png", 400, 200, 0, 0)
		vAddEntityToScene(floor, &SceneMain)
	}

	camera.zoom = 0.5
	camera.offset = r.Vector2{f32(game.width/2), f32(game.height/2)}
}

SceneMainUpdate :: proc () {
	PlayerUpdate(&player)

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

