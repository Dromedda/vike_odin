package main

import r "vendor:raylib"
import f "core:fmt"

SceneTest : Scene = {
	id = "test",
	init = SceneTestInit,
	update = SceneTestUpdate,
	draw = SceneTestDraw,
	end = SceneTestEnd,
}

players : [1200] Entity

SceneTestInit :: proc() {
	log("SCENE TEST LOADING")
	vBenchmarkTimerStart()
	for i := 0; i < len(players); i+= 1 {
		p : Entity= {
			x = r.GetRandomValue(0, 600), 
			y = r.GetRandomValue(0, 600), 
			w = 100,
			h = 100, 
			init = proc(self: ^Entity) {
				self.sprite = vLoadTexture2d("./Assets/bob.png")
			},
			update = proc(self: ^Entity) {
			},
			draw = proc(self: ^Entity) {
				txt_src : r.Rectangle = {0.0, 0.0, f32(self.sprite.width), f32(self.sprite.height)} 
				txt_dest : r.Rectangle = {f32(self.x), f32(self.y), f32(self.sprite.width), f32(player.sprite.height)} 
				txt_origin : r.Vector2 = {0, 0}

				pcol := getRandomColor()
				r.DrawTexturePro(player.sprite, txt_src, txt_dest, txt_origin, 0, pcol)
			},
		}
		f.println("Created:: ", p)
		p.init(&p)
		players[i] = p
		vAddEntity(players[i])
	}
	vBenchmarkTimerLog("TEST SCENE")
}

SceneTestUpdate :: proc() {
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
	for p in players {
		vUnloadTexture2d(p.sprite)
	}
}

getRandomColor :: proc() -> r.Color {
	val := r.GetRandomValue(0, 4)
	ret : r.Color
	switch(val) {
		case 0:
			ret = r.RED
		case 1: 
			ret = r.GREEN
		case 2: 
			ret = r.YELLOW
		case 3: 
			ret = r.BROWN
		case 4: 
			ret = r.MAGENTA
		case: 
			ret = r.BLUE
	}
	return ret
}
