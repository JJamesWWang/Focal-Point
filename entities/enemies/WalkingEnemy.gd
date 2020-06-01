extends Enemy

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.LEFT
export(int) var LEFT_BOUND
export(int) var RIGHT_BOUND
export(int) var pause_time = 3

var start_x
var motion_x

onready var sprite: Sprite = $Sprite
onready var floor_left: RayCast2D = $FloorLeft
onready var floor_right: RayCast2D = $FloorRight
onready var wall: RayCast2D = $Wall
onready var patrol_timer: Timer = $PatrolTimer
onready var hurtbox: Area2D = $Hurtbox
onready var collider: Area2D = $Collider


func _ready():
	start_x = position.x
	motion.x = SPEED * WALKING_DIRECTION
	patrol_timer.wait_time = pause_time


# Basically rotates the beam so that it's pointed at the mouse. It also doesn't rotate
# 360 degrees, so it doesn't flip upside down and is like a little turtle tank.
func _process(_delta: float) -> void:
	var rotation_angle = get_local_mouse_position().angle() + deg2rad(90)
	if rotation_angle < 0 or rotation_angle > deg2rad(180):
		rotation_angle = 0
	elif rotation_angle > deg2rad(90):
		rotation_angle  = deg2rad(90)
	sprite.rotation = rotation_angle
	hurtbox.rotation = rotation_angle
	collider.rotation = rotation_angle


# Checks for two cases in which special action needs to occur: 
func _physics_process(_delta: float) -> void:
	if not floor_right.is_colliding() or not floor_left.is_colliding() or wall.is_colliding():
		patrol_flip()
	if not in_patrol_area():
		return_to_patrol_area()
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 8, Vector2.UP, true, 4, deg2rad(46))


# A check to see if it's in the right direction
func return_to_patrol_area() -> void:
	# Needs to check for this as this function will be called on constantly if 
	# the enemy ever gets knocked out of its patrol area. If it's int he right
	# direction, no need to perform a patrol flip. if not in right direction, 
	# it hasn't performed a patrol flip and will perform one.
	if not check_direction():
		patrol_flip()


# Like a patrol man, it stops, and flips itself around.
func patrol_flip() -> void:
	WALKING_DIRECTION *= -1
	motion.x = 0
	patrol_timer.start()
	wall.scale.x *= -1
	

# Checks if taking one step would take the enemy away or towards the patrol area.
func check_direction() -> bool:
	var compare_val = position.x + WALKING_DIRECTION
	var compare_to_start = abs(compare_val - start_x)
	var dist_to_start = abs(position.x - start_x)
	if compare_to_start < dist_to_start:
		return true
	else: 
		return false

# A check to see if the enemy is in the patrol area.
func in_patrol_area() -> bool:
	var right_bound = start_x + RIGHT_BOUND
	var left_bound = start_x - LEFT_BOUND
	
	if position.x >= left_bound and position.x <= right_bound:
		return true
	else:
		return false


func _on_PatrolTimer_timeout() -> void:
	motion.x = SPEED * WALKING_DIRECTION
