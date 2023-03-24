package main

import r "vendor:raylib"
import f "core:fmt"

Player :: struct {
	speed : f64,
	sprint_multiplyer: f64,
	facing_dir: f32,
	using entity: Entity,
}

PlayerInit :: proc(self: ^Player, xx: i32, yy: i32) {	
	log("CREATED PLAYER")
	self.x = xx
	self.y = yy
	self.w = 16
	self.h = 16
	self.speed = 5.0
	self.sprint_multiplyer = 2.0
	self.facing_dir = 1
	self.sprite = vCreateSprite("./Assets/player.png", 16, 16, 8, 8)
	vCreateAnimation(self.sprite, 0, 3)
	vCreateAnimation(self.sprite, 1, 11)
	self.sprite.current_animation = 0
}

PlayerUpdate :: proc(self: ^Player) {
	spd:= self.speed
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))


	if moveX != 0 {
		self.facing_dir = f32(moveX)
	}

	if (moveX != 0 && moveY != 0) { spd = spd * 0.8 }

	// TODO: Make this built into the sprite
	target_anim_speed :f32 = 0

	if (moveX != 0 || moveY != 0) {
		self.sprite.current_animation = 1
		target_anim_speed = 24
	} else {
		self.sprite.current_animation = 0
		target_anim_speed = 4
	}

	if (moveX < 0) {
		self.sprite.flippedH = true
	} else if (moveX > 0) {
		self.sprite.flippedH = false
	}

	if (vkeyd(r.KeyboardKey.LEFT_SHIFT)) {
		spd = spd * self.sprint_multiplyer
		target_anim_speed = target_anim_speed * 2
	}

	self.x += moveX * i32(spd); 
	self.y += moveY * i32(spd); 

	vUpdateAnimation(&self.sprite, target_anim_speed)
}

PlayerDraw :: proc(self: ^Player) {
	vDrawSprite(self.sprite, self.x, self.y, 6.0, 6, 0, r.WHITE)
}

PlayerEnd :: proc(self: ^Player) {
	log("ENDING PLAYER")
	// vUnloadTexture2d(self.sprite)
}
