extends CharacterBody2D

@export var movement_data: PlayerMovementData

var jumping = false
var landing = false
var can_double_jump = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var landing_zone: CollisionPolygon2D = %LandingZone
@onready var coyote_jump_timer: Timer = %CoyoteJumpTimer
@onready var landing_timer: Timer = %LandingTimer


func _physics_process(delta: float) -> void:
	process_gravity(delta)
	process_jump()
	process_movement(delta)
	process_animations()
	manage_landing()
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_floor = was_on_floor != is_on_floor() and !is_on_floor()
	manage_coyote_timer(just_left_floor)
	
	landing = !was_on_floor and is_on_floor()
	
		
func process_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func process_jump():
	if is_on_floor():
		jumping = false
		can_double_jump = true
		if Input.is_action_just_pressed("jump"):
			jump()
	elif coyote_jump_timer.time_left > 0 and !jumping:
		if Input.is_action_just_pressed("jump"):
			jump()
	elif can_double_jump:
		if Input.is_action_just_pressed("jump"):
			jump()
			can_double_jump = false
		
func process_movement(delta):
	var input_axis = get_input_axis()
	if input_axis:
		if is_on_floor():
			accelerate(input_axis)
		else:
			air_acceleration(input_axis)
			
	else:
		friction()
		
func process_animations():
	var input_axis = get_input_axis()
	if abs(input_axis) > 0 or jumping:
		if jumping:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("run")
		if input_axis > 0:
			animated_sprite.flip_h = false
		if input_axis < 0:
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")

func get_input_axis():
	var input_axis := Input.get_axis("left", "right")
	return input_axis

func accelerate(axis):
	velocity.x = move_toward(velocity.x, axis * movement_data.speed, movement_data.acceleration)
		
func air_acceleration(axis):
	velocity.x = move_toward(velocity.x, axis * movement_data.speed, movement_data.air_acceleration)
	
func friction():
	velocity.x = move_toward(velocity.x, 0, movement_data.friction)

func run():
	if !jumping:
		animated_sprite.play("run")

func jump():
	velocity.y = movement_data.jump_velocity
	jumping = true
		
func double_jump():
	velocity.y = movement_data.jump_velocity * movement_data.double_jump_velocity
	jumping = true
	can_double_jump = false

func manage_coyote_timer(just_left_floor):
	if just_left_floor and velocity.y >= 0:
		coyote_jump_timer.start()
	if coyote_jump_timer.time_left > 0:
		print("Coyote jump active!!!")
	if jumping or is_on_floor():
		coyote_jump_timer.stop()

func manage_landing():
	if landing:
		print("landing!")
		animated_sprite.play("jump_land")
		landing_timer.start()
		if landing_timer.timeout:
			landing = false
