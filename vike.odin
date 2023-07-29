package main

import r "vendor:raylib"
import "core:fmt"
import "core:strings"

DEBUG_LOG_TOTAL_LIMIT :: 50
DEBUG_LOG_LINE_HEIGHT :: 16
DEBUG_LOG_CONSOLE_OFFSET :: 8
DEBUG_LOG_LINE_OFFSET :: 4

// -- @Data -- // 

// Main Game Struct, used to keep track of the state of the game
Game :: struct {
	scenes : [dynamic]^Scene,
	activeScene : ^Scene,
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
	target_fps: [dynamic] f32,
	origin: r.Vector2,
	flippedH: bool,
	flippedV: bool,
}

Tile :: struct {
	name: string,
	texture: r.Texture2D, 
	x,y,w,h : i32,
}

// -- @Flow -- // 

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


// -- @Scene & @Entity Handling -- // 

// Creates an entity of type t, as long as the type derives from entity
vCreateEntity :: proc($T: typeid, name: string) -> T {
	t := new(T)
	t.name = name
	return t^
} 

// Adds an entity to the scene
vAddEntityToScene :: proc(e: Entity,scn: ^Scene) -> Scene {
	assert(type_of(e) == Entity)
	append(&scn.entities, e)
	fmt.println("Added Entity::", e.name, " To Scene::", scn.id)
	return scn^
}

// Adds a scene to the game, If no other scene has been added it will set the provided scene to active
vAddScene :: proc(scn: ^Scene) {
	if (len(game.scenes) == 0) {
		game.activeScene = scn
	}
	append(&game.scenes, scn)
	fmt.println("Added Scene To Game::", scn)
}

// Goes to a scene, inits that scene and end the previusly active one.
vGotoScene :: proc(id: string) -> (ret: ^Scene) {
	for scene in game.scenes {
		if scene.id == id { ret = scene } 
	}
	assert(ret.id != "", "CANNOT FIND SCENE \n Did you add it to the game struct?")
	game.activeScene.end()
	game.activeScene = ret
	game.activeScene.init()
	return ret
}


// -- "@Physics" -- // 

// Returns a list of all colliding entities,
vGetAllCollidingEntities :: proc(self: ^Entity, scn: ^Scene) -> (ret:[dynamic]Entity) {
	for i := 0; i < len(scn.entities); i += 1 {
		if (vCheckMeetingE(self, &scn.entities[i])) {
			append(&ret, scn.entities[i])
		}
	} 
	return 
}

// Checks if 2 entities are overlapping
vCheckMeetingE :: proc(a: ^Entity, b: ^Entity) -> bool {
	if(a.x < b.x + b.w) && 
		(a.x + a.w > b.x) && 
		(a.y < b.y + b.h) &&
		(a.y + a.h > b.y) {
		return true
	}
	return false
}

// -- @Sprite Drawing -- // 

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
		append(&spr.target_fps, 0)
	}
	return
}

// TODO: Set the frame time here instead of in the update so that each animation has its own frame times
// Creates an Animation, param animation is the row(Indexed from 0) in the sheet to use
vCreateAnimation :: proc(spr: Sprite, animation: i32, num_of_frames: i32, target_fps: f32) {
	spr.animation_frames[animation] = num_of_frames 
	spr.target_fps[animation] = target_fps
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

// Sets the TargetFPS for an animation for a sprite
vSetAnimationFPS :: proc(spr: ^Sprite, animation: i32, target_fps: f32) {
	spr.target_fps[animation] = target_fps
}

// Updates the frame times of the currently active animation in a sprite 
vUpdateAnimation :: proc(spr: ^Sprite) {
	spr.frame_time[spr.current_animation] += r.GetFrameTime()
	if spr.current_frame > spr.animation_frames[spr.current_animation] {
		spr.current_frame = 0
	}
	if (spr.frame_time[spr.current_animation] >= 1 / spr.target_fps[spr.current_animation]) {
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


// -- @Random @Utils -- //

// Yeets a string to the term and in game log 
log :: proc(str: string) {
	fmt.println("VIKE::LOG::", str)
	vDebugLog(strings.clone_to_cstring(str))
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

@(private="file")
debugStringLog : [dynamic]cstring
// Print Something to the "ingame log". we'd wanna accept multiple params 
vDebugLog :: proc(str: cstring) {
	inject_at(&debugStringLog, 0, str)
	if (len(debugStringLog) > DEBUG_LOG_TOTAL_LIMIT) {
		pop(&debugStringLog);
	}
}

// Draws the debug log in the top left corner
vDebugDrawLog :: proc() {
	r.DrawRectangle(DEBUG_LOG_CONSOLE_OFFSET/2, 8, 400, i32(DEBUG_LOG_CONSOLE_OFFSET+ ( len(debugStringLog) * DEBUG_LOG_LINE_HEIGHT + DEBUG_LOG_LINE_OFFSET)), r.Color{20, 20, 20, 90})
	if (len(debugStringLog) > 0) {
		for i := 0; i < len(debugStringLog); i += 1 { 
			r.DrawText( debugStringLog[i],
									8, 
									i32(DEBUG_LOG_CONSOLE_OFFSET+ (i * DEBUG_LOG_LINE_HEIGHT + DEBUG_LOG_LINE_OFFSET)), 
									DEBUG_LOG_LINE_HEIGHT, 
									r.RED)
		}
	}
}

// Clears all the debug log entries
vDebugLogClear :: proc() {
	clear(&debugStringLog)
}


// -- @Input -- // 

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
