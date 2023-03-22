package main
import r "vendor:raylib"
import "core:fmt"

Game :: struct {
	entities : [dynamic]Entity,
	scenes : [dynamic]Scene,
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

vGameInit :: proc () {
	assert(len(game.scenes) != 0, "CANNOT INIT SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.init()
}

vGameUpdate :: proc() {
	assert(len(game.scenes) != 0, "CANNOT UPDATE SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.update()
}

vGameDraw :: proc() {
	assert(len(game.scenes) != 0, "CANNOT DRAW SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.draw()
}

vGameEnd :: proc() {
	assert(len(game.scenes) != 0, "CANNOT END SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.end()
}

vAddEntity :: proc(e: Entity) {
	append(&game.entities, e)
	fmt.println("Added Entity To Game::", e)
}

vAddScene :: proc(scn: Scene) {
	if (len(game.scenes) == 0) {
		game.activeScene = scn
	}
	append(&game.scenes, scn)
	fmt.println("Added Scene To Game::", scn)
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

vLoadTexture2d :: proc(src : cstring) -> r.Texture2D {
	return r.LoadTexture(src)
}

vUnloadTexture2d :: proc(tx : r.Texture2D) {
	r.UnloadTexture(tx)
}

log :: proc(str: string) {
	fmt.println("VIKE::LOG::", str)
}

@(private="file")
benchmarkTimerStartTime : f64

vBenchmarkTimerStart :: proc() {
	benchmarkTimerStartTime = r.GetTime()
}

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
