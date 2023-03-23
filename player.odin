package main

import r "vendor:raylib"
import f "core:fmt"

Player :: struct {
	speed : f64,
	sprint_multiplyer: f64,
	using entity: Entity,
}

PlayerInit :: proc(self: ^Player, xx: i32, yy: i32) {	
	log("CREATED PLAYER")
	self.x = xx
	self.y = yy
	self.w = 32
	self.h = 32
	self.speed = 5.0
	self.sprint_multiplyer = 2.0
	self.sprite = vLoadTexture2d("./Assets/bob.png")
}

PlayerUpdate :: proc(self: ^Player) {
	spd:= self.speed
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))

	if (vkeyd(r.KeyboardKey.LEFT_SHIFT)) {
		spd = spd * self.sprint_multiplyer
	}

	if (moveX != 0 && moveY != 0) { spd = spd * 0.8 }

	self.x += moveX * i32(spd); 
	self.y += moveY * i32(spd); 
}

PlayerDraw :: proc(self: ^Player) {
	txt_src : r.Rectangle = {0.0, 0.0, f32(self.sprite.width), f32(self.sprite.height)} 
	txt_dest : r.Rectangle = {f32(self.x), f32(self.y), f32(self.sprite.width), f32(self.sprite.height)} 
	txt_origin : r.Vector2 = {0, 0}
	r.DrawTexturePro(self.sprite, txt_src, txt_dest, txt_origin, 0, r.RED)
}

PlayerEnd :: proc(self: ^Player) {
	log("ENDING PLAYER")
	vUnloadTexture2d(self.sprite)
}
