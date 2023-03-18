package main
import r "vendor:raylib"
import f "core:fmt"

@(private="file")
PlayerSpeed: f64 = 5

@(private="file")
SprintMultiplier: f64 = 2.4

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
	player.sprite = vLoadTexture2d("./Assets/bob.png")
}

PlayerUpdate :: proc(self: ^Entity) {
	spd:= PlayerSpeed
	moveX := (i32(vkeyd(r.KeyboardKey.D)) - i32(vkeyd(r.KeyboardKey.A)))
	moveY := (i32(vkeyd(r.KeyboardKey.S)) - i32(vkeyd(r.KeyboardKey.W)))

	// Sprinting
	if (vkeyd(r.KeyboardKey.LEFT_SHIFT)) {
		spd = spd * SprintMultiplier
	}

	// Normalize if we are moving diagonally
	if (moveX != 0 && moveY != 0) { spd = spd * 0.8 }

	self.x += moveX * i32(spd); 
	self.y += moveY * i32(spd); 
}

PlayerDraw :: proc(self: ^Entity) {
	txt_src : r.Rectangle = {0.0, 0.0, f32(player.sprite.width), f32(player.sprite.height)} 
	txt_dest : r.Rectangle = {f32(player.x), f32(player.y), f32(player.sprite.width), f32(player.sprite.height)} 
	txt_origin : r.Vector2 = {0, 0}
	r.DrawTexturePro(player.sprite, txt_src, txt_dest, txt_origin, 0, r.RED)
}
