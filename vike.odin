package main

import r "vendor:raylib"
import "core:fmt"


// -- Data -- // 

// Main Game Struct, used to keep track of the state of the game
Game :: struct {
	scenes : [dynamic]Scene,
	activeScene : Scene,
	width : i32,
	height : i32,
	debug : bool,
}

// An Entity is a thing that has logic, similar to an object/node in engines like GMS and Godot
Entity :: struct {
	name: string,
	x,y,w,h: i32,
	sclx, scly: f32,
	sprite : Sprite,
}

// A scene is litterly just a scene, with a few "methods" which handle the scene state and interactivity
Scene :: struct {
	id: string,
	entities : [dynamic]Entity,
	tiles: [dynamic]Tile,
	init: proc(),
	update: proc(),
	draw: proc(),
	end: proc(),	
}

Sprite :: struct {
	texture: r.Texture2D,
	frame_width: f32, 
	frame_height: f32,
	current_frame: i32, // The col in the sheet
	current_animation: i32, // The Row in the sheet
	animation_frames: [dynamic]i32,
	frame_time: [dynamic]f32,
	origin: r.Vector2,
	flippedH: bool,
	flippedV: bool,
}


Tile :: struct {
	name: string,
	texture: r.Texture2D, 
	x,y,w,h : i32,
}

// -- Flow -- // 

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


// -- Scene & Entity Handling -- // 

// Adds an entity to the scene
vAddEntityToScene :: proc(e: Entity,scn: ^Scene) {
	append(&scn.entities, e)
	fmt.println("Added Entity::", e, " To Scene::", scn.id)
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
vGotoScene :: proc(id: string) -> (ret: Scene) {
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

// -- "Physics" -- // 

// TODO: make a func that returns all colliding entities

// Checks if 2 entities are overlapping
vCheckMeetingE :: proc(a: ^Entity, b: ^Entity) -> bool {
	if 	(a.x < b.x + b.w) && 
			(a.x + a.w > b.x) && 
			(a.y < b.y + b.h) &&
			(a.y + a.h > b.y) {
		return true
	}
	return false
}

// Checks if entity is overlapping with Tile
vCheckMeetingT :: proc(a: ^Entity, b: ^Tile) -> bool {
	if 	(a.x < b.x + b.w) && 
			(a.x + a.w > b.x) && 
			(a.y < b.y + b.h) &&
			(a.y + a.h > b.y) {
		return true
	}
	return false
}

// -- Tile Drawing -- // 
// TODO: Implement
/*
	NOTE: might wanna look into the export from tiles, or similar editors, or just figure out how to do it 
	youself, perhaps create a crude map editor
*/

// -- Sprite Drawing -- // 

// Create a drawable sprite, useful when using vDrawSprite
vCreateSprite :: proc(txt: cstring, frame_width: f32, frame_height: f32, origin_x: f32, origin_y: f32) -> (spr: Sprite){
	spr.texture = vLoadTexture2d(txt)
	spr.frame_width, spr.frame_height = frame_width, frame_height
	spr.origin = r.Vector2{origin_x, origin_y}
	spr.current_frame = 0
	spr.current_animation = 0
	max_anims := spr.texture.width / i32(frame_width)
	// this is ugly but it works ? 
	for i:i32=0; i < max_anims; i+= 1 {
		append(&spr.animation_frames, 0)
		append(&spr.frame_time, 0)
	}
	return
}

// TODO: Set the frame time here instead of in the update so that each animation has its own frame times
// Creates an Animation, param animation is the row(Indexed from 0) in the sheet to use
vCreateAnimation :: proc(spr: Sprite, animation: i32, num_of_frames: i32,) {
	spr.animation_frames[animation] = num_of_frames 
}

// Loads a texture, this Proc is quite useless right now
vLoadTexture2d :: proc(src: cstring) -> (r.Texture2D) {
	return r.LoadTexture(src)
}

// Draws a Create sprite
vDrawSprite :: proc(spr: Sprite, x: i32, y:i32, sclx:f32, scly:f32, rot:f32, col:r.Color) {
	srcx := f32(spr.current_frame) * spr.frame_width
	srcy := f32(spr.current_animation) * spr.frame_height
	src := r.Rectangle{srcx, srcy, f32(spr.frame_width), f32(spr.frame_height)}
	if (spr.flippedH) {	src = r.Rectangle{srcx, srcy, f32(-spr.frame_width), f32(spr.frame_height)} }
	if (spr.flippedV) {	src = r.Rectangle{srcx, srcy, f32(spr.frame_width), f32(-spr.frame_height)}	}
	dest := r.Rectangle{f32(x), f32(y), spr.frame_width * sclx, spr.frame_height * scly}
	r.DrawTexturePro(spr.texture, src, dest, spr.origin, rot, col)
}

// Gets the current active sprite.. Same as spr.current_animation
vGetCurrentAnimation :: proc(spr: ^Sprite) -> (i32) {
	return spr.current_animation
}

// Updates the frame times of the currently active animation in a sprite 
vUpdateAnimation :: proc(spr: ^Sprite, target_fps: f32) {
	spr.frame_time[spr.current_animation] += r.GetFrameTime()
	if spr.current_frame > spr.animation_frames[spr.current_animation] {
		spr.current_frame = 0
	}
	if (spr.frame_time[spr.current_animation] >= 1 / target_fps ) {
		if (spr.current_frame < spr.animation_frames[spr.current_animation]-1) {
			spr.current_frame += 1
		} else {
			spr.current_frame = 0
		}
		spr.frame_time[spr.current_animation] = 0
	}
}

// Same as with vLoadTexture, this Proc is quite useless right now
vUnloadTexture2d :: proc(tx: r.Texture2D) {
	r.UnloadTexture(tx)
}


// -- Random Utils -- //

// Yeets a string to the term 
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


// -- Input -- // 

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
