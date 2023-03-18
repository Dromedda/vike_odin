package main
import r "vendor:raylib"
import f "core:fmt"

SceneMain : Scene = {
	id = "main",
	init = SceneMainInit,
	update = SceneMainUpdate,
	draw = SceneMainDraw,
	end = SceneMainEnd,
}

SceneTest : Scene = {
	id = "test",
	init = SceneTestInit,
	update = SceneTestUpdate,
	draw = SceneTestDraw,
	end = SceneTestEnd,
}

// -- MAIN SCENE -- // 
SceneMainInit :: proc () {
	log("SCENE MAIN LOADED")
	player.init(&player)
}

SceneMainUpdate :: proc () {
	player.update(&player)
	if (vkeyr(r.KeyboardKey.F1)) {
		vGotoScene("test")
	}
}

SceneMainDraw :: proc () {
	r.ClearBackground(r.LIGHTGRAY)
	r.DrawText("MAIN SCENE", 8, 48, 32, r.DARKGRAY)
	player.draw(&player)
}

SceneMainEnd :: proc () {
	log("CLOSING MAIN SCENE")
}

players : [2000] Entity

// -- TEST SCENE -- // 
SceneTestInit :: proc () {
	log("SCENE TEST LOADED")
	for i := 0; i < len(players); i+= 1 {
		p : Entity= {
			x = 300, 
			y = 200, 
			w = 100,
			h = 100, 
			init = proc (self: ^Entity) {
				self.sprite = vLoadTexture2d("./Assets/bob.png")
			},
			update = proc(self: ^Entity) {
			},
			draw = proc(self: ^Entity) {
				txt_src : r.Rectangle = {0.0, 0.0, f32(self.sprite.width), f32(self.sprite.height)} 
				txt_dest : r.Rectangle = {f32(self.x), f32(self.y), f32(self.sprite.width), f32(player.sprite.height)} 
				txt_origin : r.Vector2 = {0, 0}
				r.DrawTexturePro(player.sprite, txt_src, txt_dest, txt_origin, 0, r.RED)
			},
		}
		f.println("Created:: ", p)
		p.init(&p)
		players[i] = p
	}
}

SceneTestUpdate :: proc () {
	if (vkeyr(r.KeyboardKey.F1)) {
		vGotoScene("main")
	}
	for i := 0; i < len(players); i += 1 {
		players[i].update(&players[i])
	}
}

SceneTestDraw :: proc() {
	r.ClearBackground(r.LIGHTGRAY)
	r.DrawText("TEST SCENE", 8, 48, 32, r.DARKGRAY)
	for i := 0; i < len(players); i += 1 {
		players[i].draw(&players[i])
	}
}

SceneTestEnd :: proc () {
	log("CLOSING TEST SCENE")
	for i := 0; i < len(players); i+= 1 {
		vUnloadTexture2d(players[i].sprite)	
	}
}
