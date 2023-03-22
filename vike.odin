package main

import r "vendor:raylib"
import "core:fmt"

// Main Game Struct, used to keep track of the state of the game
Game :: struct {
	entities : [dynamic]Entity,
	scenes : [dynamic]Scene,
	activeScene : Scene,
	width : i32,
	height : i32,
}

// An Entity is a thing that has logic, similar to an object/node in engines like GMS and Godot
Entity :: struct {
	x,y,w,h: i32,
	init: proc(self:^Entity),
	update: proc(self:^Entity),
	draw: proc(self:^Entity),
	end: proc(self:^Entity),
	sprite : r.Texture2D,
}

// A scene is litterly just a scene, with a few "methods" which handle the scene state and interactivity
Scene :: struct {
	id: string,
	entities : [dynamic]Entity,
	init: proc(),
	update: proc(),
	draw: proc(),
	end: proc(),	
}

// Used to Init the currently active scene
vGameInit :: proc() {
	assert(len(game.scenes) != 0, "CANNOT INIT SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.init()
}

// Used to Update the currently active scene
vGameUpdate :: proc() {
	assert(len(game.scenes) != 0, "CANNOT UPDATE SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.update()
}

// Used to Draw the currently active scene
vGameDraw :: proc() {
	assert(len(game.scenes) != 0, "CANNOT DRAW SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.draw()
}

// Used to close and End the currently active scene
vGameEnd :: proc() {
	assert(len(game.scenes) != 0, "CANNOT END SCENE.. \n Did you add the scene to the game with vAddScene()")
	game.activeScene.end()
}

// NOTE: Might wanna make this local to the scene instead of the game
// Adds an entity to the game
vAddEntity :: proc(e: Entity) {
	append(&game.entities, e)
	fmt.println("Added Entity To Game::", e)
}

// Adds a scene to the game, If no other scene has been added it will set the provided scene to active
vAddScene :: proc(scn: Scene) {
	if (len(game.scenes) == 0) {
		game.activeScene = scn
	}
	append(&game.scenes, scn)
	fmt.println("Added Scene To Game::", scn)
}

// Goes to a scene, inits that scene and end the previusly active one.
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

// Loads a texture, this Proc is quite useless right now
vLoadTexture2d :: proc(src: cstring) -> (r.Texture2D) {
	return r.LoadTexture(src)
}

// Same as with vLoadTexture, this Proc is quite useless right now
vUnloadTexture2d :: proc(tx: r.Texture2D) {
	r.UnloadTexture(tx)
}

// Yeets a string to the term output 
log :: proc(str: string) {
	fmt.println("VIKE::LOG::", str)
}

@(private="file")
benchmarkTimerStartTime : f64

// Starts a timer, use vBenchmarkTimerLog() to log the time between that and this proc call.
vBenchmarkTimerStart :: proc() {
	benchmarkTimerStartTime = r.GetTime()
}

// Prints the diff in time since we called vBenchmarkTimerStart().
vBenchmarkTimerLog :: proc(inst: string) -> f64{
	endTime := r.GetTime()
	res := endTime - benchmarkTimerStartTime
	fmt.println(inst," Benchmark Took: ", res, "ms")
	benchmarkTimerStartTime = 0.0
	return res
}

// I have no idea what this was supposed to be? maybe to get the r.KeyboardKey enums?
vk :: proc (k: string) {
	assert(false, "Not Implemented Yet...")
}

// Checks if provided key has been pressed.
vkeyp :: proc(key: r.KeyboardKey) -> bool {
	return r.IsKeyPressed(key)
}

// Checks if the provided key has been released.
vkeyr :: proc(key: r.KeyboardKey) -> bool {
	return r.IsKeyReleased(key)
}

// Checks if the provided key is down.
vkeyd :: proc(key: r.KeyboardKey) -> bool {
	return r.IsKeyDown(key)
}
