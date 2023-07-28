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
	self.w = 16 * 4
	self.h = 16 * 4
	self.speed = 4
	self.sprint_multiplyer = 2
	self.facing_dir = 1
	self.sprite = vCreateSprite("./Assets/player.png", 16, 16, 0, 0)
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

	target_anim_speed :f32 = 0

	if (moveX != 0 || moveY != 0) {
		self.sprite.current_animation = 1
		target_anim_speed = 24
	} else {
		self.sprite.current_animation = 0
		target_anim_speed = 4
	}

	ents := vGetAllCollidingEntities(self, game.activeScene)
	for e in ents {
		f.println("Touching :: ", e.name)
	}

	if (moveX != 0) { self.sprite.flippedH = (moveX < 0) }

	if (vkeyd(r.KeyboardKey.LEFT_SHIFT)) {
		spd = spd * self.sprint_multiplyer
		target_anim_speed = target_anim_speed * 2
	}

	if (moveX != 0 && moveY != 0) { spd = spd / 1.2 }
	
	self.x += moveX * i32(spd) 
	self.y += moveY * i32(spd) 

	vUpdateAnimation(&self.sprite, target_anim_speed)
}

PlayerDraw :: proc(self: ^Player) {
	r.DrawRectangle(self.x - i32(self.sprite.origin.x), self.y - i32(self.sprite.origin.y), self.w, self.h, r.BLUE)
	vDrawSprite(self.sprite, self.x, self.y, 4, 4, 0, r.WHITE)
}

PlayerEnd :: proc(self: ^Player) {
	log("ENDING PLAYER")
	vUnloadTexture2d(self.sprite.texture)
}
