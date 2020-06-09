extends Enemy

onready var sprite: Sprite = $Sprite
onready var floor_cast: RayCast2D = $FloorCast
onready var back_floor_cast: RayCast2D = $BackFloorCast


func _physics_process(_delta: float) -> void:
	follow_mouse()


func follow_mouse() -> void:
	var distance_to_mouse = get_global_mouse_position().x - position.x
	var facing_direction = int(sign(distance_to_mouse))
	
	# Prevents jumping off cliffs
	if not floor_cast.is_colliding() and back_floor_cast.is_colliding() and facing_direction == 1:
		motion.x = 0
	elif not back_floor_cast.is_colliding() and facing_direction == -1:
		motion.x = 0
	elif facing_direction != 0:
		motion.x = SPEED * facing_direction
	
	# Prevents spazzing. Basically prevents x motion shifting rapidly when the 
	# cursor is on the enemy.
	if distance_to_mouse < 2 and distance_to_mouse > -2:
		motion.x = 0
	
	motion = move_and_slide(motion, Vector2.UP)
