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

	vCreateAnimation(self.sprite, 0, 3, 4) // idle
	vCreateAnimation(self.sprite, 1, 11, 24) // walking
	vCreateAnimation(self.sprite, 1, 11, 48) // running (same anim as walking but faster)
	self.sprite.current_animation = 0
}

PlayerUpdate :: proc(self: ^Player) {
	spd:= self.speed
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))

	// Decide Animations
	if (moveX != 0 || moveY != 0) {
		vSetCurrentAnimation(&self.sprite, 1) 
	} else {
		vSetCurrentAnimation(&self.sprite, 0)
	}

	// Sprinting
	if (vkeyd(r.KeyboardKey.LEFT_SHIFT)) {
		spd = spd * self.sprint_multiplyer
		vSetAnimationFPS(&self.sprite, 1, 54)
	} else {
		vSetAnimationFPS(&self.sprite, 1, 24)
	}

	// Flip Player & normalize Diagonals
	if moveX != 0 {
		self.facing_dir = f32(moveX)
		self.sprite.flippedH = (moveX < 0)
		if moveY != 0 { spd = spd / 1.2}
	}

	target := self
	target.x += moveX * i32(spd)
	target.y += moveY * i32(spd)
	
	floor := vGetEntity("floor") 
	if (vCheckMeetingE(target, &floor)) {
		vDebugLog("Touching Floor1")
	}

	floor2 := vGetEntity("floor2") 
	if (vCheckMeetingE(target, &floor2)) {
		vDebugLog("Touching Floor2")
	}

	// update anim's and apply speed
	self.x = target.x
	self.y = target.y

	vUpdateAnimation(&self.sprite)
}

PlayerDraw :: proc(self: ^Player) {
	// Check Collisions
	ents := vGetAllCollidingEntities(self, game.activeScene) 
	if (len(ents) > 0) { r.DrawRectangle(self.x - i32(self.sprite.origin.x), self.y - i32(self.sprite.origin.y), self.w, self.h, r.RED) }

	// Draw Self
	vDrawSprite(self.sprite, self.x, self.y, 4, 4, 0, r.WHITE)
}

PlayerEnd :: proc(self:^Player) {
	vUnloadTexture2d(self.sprite.texture)
}
