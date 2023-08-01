package main

import r "vendor:raylib"
import f "core:fmt"

Player :: struct {
	speed : f64,
	sprint_multiplyer: f64,
	using entity: Entity,
}

PlayerInit :: proc(self: ^Player, xx: i32, yy: i32) {	
	self.x = xx
	self.y = yy
	self.sclx = 4
	self.scly = 4
	self.w = 16 * i32(self.sclx)
	self.h = 16 * i32(self.scly)
	self.speed = 4
	self.sprint_multiplyer = 2
	self.sprite = vCreateSprite("./Assets/player.png", 16, 16, 0, 0)

	vCreateAnimation(self.sprite, 0, 3, 4) // idle
	vCreateAnimation(self.sprite, 1, 11, 24) // walking
	vCreateAnimation(self.sprite, 1, 11, 48) // running (same anim as walking but faster)
	self.sprite.current_animation = 0
}

PlayerUpdate :: proc(self: ^Player) {
	self.speed = 4
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
		self.speed = self.speed * self.sprint_multiplyer
		vSetAnimationFPS(&self.sprite, 1, 54)
	} else {
		vSetAnimationFPS(&self.sprite, 1, 24)
	}

	// Flip Player & normalize Diagonals
	if moveX != 0 {
		self.sprite.flippedH = (moveX < 0)
		if moveY != 0 { self.speed = self.speed/ 1.2}
	}
	
	targetx := (moveX * i32(self.speed))
	targety := (moveY * i32(self.speed))

	floor := vGetEntity("floor") 
	if (vCheckMeetingE(self, &floor)) {
		vDebugLog("Touching Floor1")
	}

	floor2 := vGetEntity("floor2") 
	if (vCheckMeetingE(self, &floor2)) {
		vDebugLog("Touching Floor2")
	}

	// update anim's and apply speed
	self.x += targetx
	self.y += targety

	vUpdateAnimation(&self.sprite)
}

PlayerDraw :: proc(self: ^Player) {
	// Check Collisions
	ents := vGetAllCollidingEntities(self, game.activeScene) 
	if (len(ents) > 0) { r.DrawRectangle(self.x - i32(self.sprite.origin.x), self.y - i32(self.sprite.origin.y), self.w, self.h, r.RED) }

	// Draw Self
	vDrawSprite(self.sprite, self.x, self.y, self.sclx, self.scly, 0, r.WHITE)

	// Debug Drawing
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))

	targetx := (self.x + 32) + (moveX * i32(self.speed)) * 10
	targety := (self.y + 32) + (moveY * i32(self.speed)) * 10

	if game.debug { 
		r.DrawLine(self.x + 32, self.y + 32, targetx, targety, r.RED)
		vDebugRecOutline(self.x, self.y, self.w, self.h, r.RED)
	}
}

PlayerEnd :: proc(self:^Player) {
	vUnloadTexture2d(self.sprite.texture)
}
