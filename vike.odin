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

Texture :: struct {
	texture : r.Texture,
	source_crop : r.Rectangle,
	destination : r.Rectangle,
	origin : r.Vector2,	
}

vLoadTexture2d :: proc(src : cstring) -> Texture {
	txture := r.LoadTexture(src)
	txture_source : r.Rectangle = {x=0, y = 0, width = f32(txture.width), height = f32(txture.height)}
	txture_dest : r.Rectangle = {x=0, y = 0, width = f32(txture.width), height = f32(txture.height)}
	txture_origin : r.Vector2 = {f32(txture.width), f32(txture.height)}

	ret : Texture = {
		texture = txture,
		source_crop = txture_source,
		destination = txture_dest,
		origin = txture_origin,
	}

	return ret 
}

vDrawTexture2d :: proc(tx : Texture, posx:i32, posy:i32, tint : r.Color) {
	r.DrawTexture(tx.texture, posx, posy, tint)
}

vDrawTexture2dPro :: proc(tx : Texture, src: r.Rectangle,dest: r.Rectangle, origin : r.Vector2, rot:i32, tint:r.Color) {
	r.DrawTexturePro(tx.texture, src, dest, origin, f32(rot), tint)
}

vUnloadTexture2d :: proc(tx : Texture) {
	r.UnloadTexture(tx.texture)
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
