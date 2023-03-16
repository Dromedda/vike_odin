package main
import r "vendor:raylib"
import f "core:fmt"

player : Entity = {
	x = 200,
	y = 200,
	w = 32,
	h = 32,
	init = PlayerInit,
	update = PlayerUpdate,
	draw = PlayerDraw,
}

PlayerInit :: proc(self: ^Entity) {
	log("CREATED PLAYER")
}

PlayerUpdate :: proc(self: ^Entity) {
	speed:f64 = 4
	
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))

	// Normalize if we are moving diagonally
	if (moveX != 0 && moveY != 0) { speed = speed * 0.8 }

	self.x += moveX * i32(speed); 
	self.y += moveY * i32(speed); 
}

PlayerDraw :: proc(self: ^Entity) {
	r.DrawRectangle(self.x, self.y, self.w, self.h, r.BLACK)
}
