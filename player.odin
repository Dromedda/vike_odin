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
	vCreateAnimation(self.sprite, 0, 3, 4)
	vCreateAnimation(self.sprite, 1, 11, 24)
	self.sprite.current_animation = 0
}

PlayerUpdate :: proc(self: ^Player) {
	spd:= self.speed
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))

	if moveX != 0 {
		self.facing_dir = f32(moveX)
	}

	if (moveX != 0 || moveY != 0) {
		vSetCurrentAnimation(&self.sprite, 1)
	} else {
		vSetCurrentAnimation(&self.sprite, 0)
	}


	if (moveX != 0) { self.sprite.flippedH = (moveX < 0) }

	if (vkeyd(r.KeyboardKey.LEFT_SHIFT)) {
		spd = spd * self.sprint_multiplyer
		vSetAnimationFPS(&self.sprite, 1, 48)
	} else {
		vSetAnimationFPS(&self.sprite, 1, 24)
	}

	if (moveX != 0 && moveY != 0) { spd = spd / 1.2 }
	
	self.x += moveX * i32(spd) 
	self.y += moveY * i32(spd) 

	vUpdateAnimation(&self.sprite)
}

PlayerDraw :: proc(self: ^Player) {
	drawColor := r.BLUE
	ents := vGetAllCollidingEntities(self, game.activeScene) 
	if (len(ents) > 0) { // Check if we are colliding with something at all
		drawColor = r.RED
	}
	//for e in ents { // Go through every entity we are colliding with
		// f.println(e)
	//}

	r.DrawRectangle(self.x - i32(self.sprite.origin.x), self.y - i32(self.sprite.origin.y), self.w, self.h, drawColor)
	vDrawSprite(self.sprite, self.x, self.y, 4, 4, 0, r.WHITE)
}

PlayerEnd :: proc(self: ^Player) {
	log("ENDING PLAYER")
	vUnloadTexture2d(self.sprite.texture)
}
