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
testEnt : Entity
floor : Entity 
camera : r.Camera2D	

SceneMainInit :: proc () {
	log("SCENE MAIN LOADING")

	game.camera = camera

	player = vCreateEntity(Player, "player")
	vAddEntityToScene(player, &SceneMain)
	PlayerInit(&player, 0, 0)

	testEnt = vCreateEntity(Entity, "testEnt")
	{
		using testEnt
		x, y = 100, 100
		w, h = 64, 64
		sclx, scly = 1, 1
		sprite = vCreateSprite("./Assets/test_sheet.png", 64, 64, 0, 0)
		vCreateAnimation(sprite, 0, 5, 2)
		vAddEntityToScene(testEnt, &SceneMain)
	}

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

	r.BeginMode2D(camera) // everything drawn here gets affected by the camera 
		vUpdateAnimation(&testEnt.sprite)
		vDrawSprite(testEnt.sprite, testEnt.x, testEnt.y, 1, 1, 0, r.WHITE)
		r.DrawTexture(floor.sprite.texture, floor.x, floor.y, r.WHITE)
		PlayerDraw(&player)
	r.EndMode2D()
}

SceneMainEnd :: proc () {
	log("CLOSING MAIN SCENE")
	vUnloadTexture2d(testEnt.sprite.texture)
	vUnloadTexture2d(floor.sprite.texture)
	PlayerEnd(&player)
}

