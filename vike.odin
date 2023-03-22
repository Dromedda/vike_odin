package main
import r "vendor:raylib"
import "core:fmt"

MAX_ENTITIES :: 200
MAX_SCENES :: 4

Game :: struct {
	entities : [MAX_ENTITIES]Entity,
	scenes : [MAX_SCENES]Scene,
	activeScene : Scene,
	width : i32,
	height : i32,
}

Entity :: struct {
	x,y,w,h: i32,
	init: proc(self:^Entity),
	update: proc(self:^Entity),
	draw: proc(self:^Entity),
	end: proc(self:^Entity),
	sprite : r.Texture2D,
}

Scene :: struct {
	id: string,
	entities : [dynamic]Entity,
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

@(private="file")
benchmarkTimerStartTime : f64

// A very basic way to check how long it takes to load things or something
vBenchmarkTimerStart :: proc() {
	benchmarkTimerStartTime = r.GetTime()
}

// stop and log the result of the ongoing benchmark thingy
vBenchmarkTimerLog :: proc(inst : string) -> f64{
	endTime := r.GetTime()
	res := endTime - benchmarkTimerStartTime
	fmt.println(inst," Benchmark Took: ", res, "ms")
	benchmarkTimerStartTime = 0.0
	return res
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
