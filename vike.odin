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

 assert(ret.id != "", "CANNOT FIND SCENE")

 // Close the current scene and init the new one 
 game.activeScene.end()
 game.activeScene = ret
 game.activeScene.init()
 return ret
}

log :: proc(str:string) {
 fmt.println("VIKE::LOG::", str)
}
