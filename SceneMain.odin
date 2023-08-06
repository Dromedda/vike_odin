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
floor2 : Entity 

SceneMainInit :: proc (self: ^Scene) {
	game.camera = r.Camera2D {}
	player = vCreateEntity(Player, "player")
	vAddEntityToScene(player, &SceneMain)
	PlayerInit(&player, -200, -100)

	floor = vCreateEntity(Entity, "floor")
	{
		using floor // allows us to omit the "floor."
		x, y = 200, 400
		w, h = 400, 64
		sclx, scly = 1, 1
		sprite = vCreateSprite("./Assets/tile.png", 400, 200, 0, 0)
		vAddEntityToScene(floor, &SceneMain)
	}

	floor2 = vCreateEntity(Entity, "floor2")
	{
		using floor2 // allows us to omit the "floor."
		x, y = 0, 0
		w, h = 400, 64
		sclx, scly = 1, 1
		sprite = vCreateSprite("./Assets/tile.png", 400, 200, 0, 0)
		vAddEntityToScene(floor2, &SceneMain)
	}

	game.camera.offset = r.Vector2{f32(game.width/2), f32(game.height/2)}
	game.camera.zoom = 1
}

SceneMainUpdate :: proc (self: ^Scene) {
	PlayerUpdate(&player)
	game.camera.target = r.Vector2{f32(player.x), f32(player.y)}
	if (game.debug) {
		if vkeyp(r.KeyboardKey.Q) { 
			game.camera.zoom = game.camera.zoom - 0.1
			vDebugLog("Camera Zoom Decreased by 0.1") 
		}
		if vkeyp(r.KeyboardKey.E) { 
			game.camera.zoom = game.camera.zoom + 0.1
			vDebugLog("Camera Zoom Increased by 0.1") 
		}
	}
}

SceneMainDraw :: proc (self: ^Scene) {
	r.ClearBackground(r.LIGHTGRAY)

	r.BeginMode2D(game.camera) // everything drawn here gets affected by the camera 
		r.DrawRectangleGradientV(-2000, -2000, 4000, 4000, r.SKYBLUE, r.DARKPURPLE)
		PlayerDraw(&player)
		r.DrawTexture(floor.sprite.texture, floor.x, floor.y, r.WHITE)
		r.DrawTexture(floor2.sprite.texture, floor2.x, floor2.y, r.WHITE)
	r.EndMode2D()
}

SceneMainEnd :: proc (self: ^Scene) {
	vUnloadTexture2d(floor.sprite.texture)
	PlayerEnd(&player)
	free(&player)
	free(&floor)
	free(&floor2)
}

