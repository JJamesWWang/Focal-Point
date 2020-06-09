extends "res://entities/enemies/floor/FloorEnemy.gd"

# Hole enemy has player falling through it. Only works with platoforms and floors of depth 1.

export (int) var DEPTH_BY_TILE = 1

const PLAYER_PIXEL_HEIGHT = 24
const TILE_PIXEL_DEPTH = 16
var main_instances = ResourceLoader.main_instances
var on_player = false


func follow_mouse() -> void:
	var player = main_instances.player
	if player != null:
		
		# If player steps on hole enemy, player doesn't collide with world.
		# Player x motion set to 0 to prevent bug where the player gets stuck
		# in an edge or accidentally crosses some kind of gap when the 
		# collsion mask is reinstated.
		if on_player:
			player.set_collision_mask_bit(0, false)
			player.motion.x = 0
		else:
			.follow_mouse()
		
		# Once the player clears one layer of tileset, reinstate player world
		# collsion. Added an extra pixel for some padding so the player doesn't
		# stick to the roof.
		if player.position.y > position.y + PLAYER_PIXEL_HEIGHT + 1 + (DEPTH_BY_TILE * TILE_PIXEL_DEPTH) and on_player:
			on_player = false
			player.set_collision_mask_bit(0, true)


func _on_Hitbox_area_entered(_area: Area2D) -> void:
	on_player = true


func _on_Hitbox_body_entered(_body: Node) -> void:
	on_player = true
