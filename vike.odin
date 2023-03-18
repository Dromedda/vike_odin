package main
import r "vendor:raylib"
import "core:fmt"

MAX_ENTITIES :: 200
MAX_SCENES :: 4

Game :: struct {
	entities : [MAX_ENTITIES]Entity,
	scenes : [MAX_SCENES]Scene,
	activeScene : Scene,
}

Entity :: struct {
	x,y,w,h: i32,
	init: proc(self:^Entity),
	update: proc(self:^Entity),
	draw: proc(selfe:^Entity),
	sprite : r.Texture2D,
}

// TODO: add textures to the assoicated scene and load them on init
// -- Also unload them on end
Scene :: struct {
	id: string,
	init: proc(),
	update: proc(),
	draw: proc(),
	end: proc(),	
}

vLoadTexture2d :: proc(src : cstring) -> r.Texture2D {
	return r.LoadTexture(src)
}



vUnloadTexture2d :: proc(tx : r.Texture2D) {
	r.UnloadTexture(tx)
}

vGotoScene :: proc(id: string) -> Scene {
	ret : Scene
	for scene in game.scenes {
		if scene.id == id {
			ret = scene
		}
	}

	assert(ret.id != "", "CANNOT FIND SCENE \n Did you add it to the game struct?")

	game.activeScene.end()
	game.activeScene = ret
	game.activeScene.init()
	return ret
}

log :: proc(str: string) {
	fmt.println("VIKE::LOG::", str)
}

vk :: proc (k:string) {
	assert(false, "Not Implemented Yet...")
}

vkeyp :: proc(key: r.KeyboardKey) -> bool {
	return r.IsKeyPressed(key)
}

vkeyr :: proc(key: r.KeyboardKey) -> bool {
	return r.IsKeyReleased(key)
}

vkeyd :: proc(key: r.KeyboardKey) -> bool {
	return r.IsKeyDown(key)
}
