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

// TODO: fix pls 
log :: proc(str:string) {
 fmt.println("VIKE::LOG::", str)
}

// --- Keyboard Input wrappers

vk :: proc (k:string) {
 assert(false, "Not Implemented yet")
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
