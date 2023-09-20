package main 

import r "vendor:raylib"

Item :: struct {
  sprite: Sprite,
  x,y: i32,
  owner: ^Entity,
}
