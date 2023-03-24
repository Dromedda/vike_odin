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
	self.w = 128
	self.h = 128
	self.speed = 5.0
	self.sprint_multiplyer = 2.0

	self.sprite = vCreateSprite("./Assets/player_sheet2.png", 128, 128, 0, 0)
	vCreateAnimation(self.sprite, 0, 3) // Red Splash
	vCreateAnimation(self.sprite, 1, 4) // Blue Splash
}

PlayerUpdate :: proc(self: ^Player) {
	spd:= self.speed
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))

	if (vkeyd(r.KeyboardKey.LEFT_SHIFT)) {
		spd = spd * self.sprint_multiplyer
	}

	if (vkeyp(r.KeyboardKey.TAB)) {
		if vGetCurrentAnimation(&self.sprite) == 1 {
			vSetCurrentAnimation(&self.sprite, 0)
		} else {
			vSetCurrentAnimation(&self.sprite, 1)
		}
	}

	if (moveX != 0 && moveY != 0) { spd = spd * 0.8 }

	self.x += moveX * i32(spd); 
	self.y += moveY * i32(spd); 

	// This is temp until we have animation specific frame times.
	target_anim_speed :f32 = 2.0
	if (vGetCurrentAnimation(&self.sprite) == 0) {
		target_anim_speed = 1
	} else {
		target_anim_speed = 12
	}

	vUpdateAnimation(&self.sprite, target_anim_speed)
}

PlayerDraw :: proc(self: ^Player) {
	vDrawSprite(self.sprite, self.x, self.y, 0, r.WHITE)
}

PlayerEnd :: proc(self: ^Player) {
	log("ENDING PLAYER")
	// vUnloadTexture2d(self.sprite)
}
