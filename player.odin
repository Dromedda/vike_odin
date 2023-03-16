package main
import r "vendor:raylib"
import f "core:fmt"

player:Entity = {
	x = 200,
	y = 200,
	w = 32,
	h = 32,

	init = proc(self:^Entity) {
		log("CREATED PLAYER")
	},

	update = proc(self:^Entity) {
		speed:i32 = 4
		self.x += (i32(vik(r.KeyboardKey.D)) - i32(vik(r.KeyboardKey.A))) * speed
		self.y += (i32(vik(r.KeyboardKey.S)) - i32(vik(r.KeyboardKey.W))) * speed
	},

	draw = proc(self:^Entity) {
		r.DrawRectangle(self.x, self.y, self.w, self.h, r.BLACK)
	},
}

