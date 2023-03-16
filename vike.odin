package main
import r "vendor:raylib"
import "core:fmt"

// CONSTANTS
MAX_ENTITIES :: 200
MAX_SCENES :: 4

Game :: struct {
 entities : [MAX_ENTITIES]Entity,
 scenes : [MAX_SCENES]Scene,
 activeScene : Scene,
}

Entity :: struct {
 x,y,w,h:i32,
 init: proc(self:^Entity),
 update: proc(self:^Entity),
 draw: proc(self:^Entity),
}

Scene :: struct {
 id: string,
 init: proc(),
 update: proc(),
 draw: proc(),
 end: proc(),
}


// Ends the current scene, and loads the new one
// if it was found in the game struct, otherwise an assert happens :)
vGotoScene :: proc(id: string) -> Scene {
 ret : Scene
 for scene in game.scenes {
  if scene.id == id {
   ret = scene
  }
 }

 assert(ret.id != "", "CANNOT FIND SCENE \n Did you add it to the game struct?")

 // Close the current scene and init the new one 
 game.activeScene.end()
 game.activeScene = ret
 game.activeScene.init()
 return ret
}

// -- Random Utils

// TODO: This will only work on strings
// checkout typeids
log :: proc(str:string) {
 fmt.println("VIKE::LOG::", str)
}

// --- Keyboard Input wrappers
/*
 instead of:
 if(r.IsKeyDown(r.KeyboardKey.A)) {
 }

 These funcs help us make it: 
 if (vik(key(a))) {
 }
*/

// TODO: return the r.KeyboardKey val of the char provided
vk :: proc (k:string) {
 assert(false, "Not Implemented yet")
}

/// Returns true of the key is pressed
vikp :: proc(key: r.KeyboardKey) -> bool {
// TODO: there is a probs a way to do ternaries
 if (r.IsKeyPressed(key)) {
  return true
 }
 return false
}


/// Returns true of the key is released
vikr :: proc(key: r.KeyboardKey) -> bool {
// TODO: there is a probs a way to do ternaries
 if (r.IsKeyReleased(key)) {
  return true
 }
 return false
}

// Returns true if the key is down
vik :: proc(key: r.KeyboardKey) -> bool {
// TODO: there is a probs a way to do ternaries
 if (r.IsKeyDown(key)) {
  return true
 }
 return false
}
