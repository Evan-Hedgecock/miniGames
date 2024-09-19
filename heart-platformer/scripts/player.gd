extends CharacterBody2D

@export var movement_data : PlayerMovementData

var jumping = false
var sprinting = false
var double_jumped = false

@onready var coyote_jump_timer: Timer = $CoyoteJumpTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	process_gravity(delta)
	process_jump()
	process_movement(delta)
	
	process_animations()
		
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor != is_on_floor() and velocity.y >= 0
	
	if just_left_ledge:
		if !jumping:
			coyote_jump_timer.start()
	
	if Input.is_action_just_pressed("sprint"):
		sprint()
	elif Input.is_action_just_released("sprint"):
		walk()
	
func process_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func process_jump():
	# If player is on floor, or the coyote jump timer is NOT stopped, then set jumping, and double_jumped to false
	if is_on_floor() or !coyote_jump_timer.is_stopped():
		jumping = false
		double_jumped = false
		if Input.is_action_just_pressed("jump"):
			jumping = true
			coyote_jump_timer.stop()
			velocity.y = movement_data.jump_velocity
	elif !is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
		if Input.is_action_just_pressed("jump") and !double_jumped:
			double_jump()
			double_jumped = true
func process_movement(delta):
	var input_axis = get_input_axis()
	if is_on_floor():
		apply_friction(input_axis, delta)
		apply_acceleration(input_axis, delta)
	elif !is_on_floor():
		apply_air_acceleration(input_axis, delta)

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_acceleration(input_axis, delta):	
	velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func apply_air_acceleration(input_axis, delta):
	velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
	
func process_animations():
	var input_axis = get_input_axis()
	if jumping:
		animated_sprite_2d.play("jump")
	elif input_axis == 0:
		if !jumping:
			animated_sprite_2d.play("idle")
	elif input_axis != 0:
		if sprinting: 
			animated_sprite_2d.speed_scale = 1.5
		else: 
			animated_sprite_2d.speed_scale = 1
		run_animation(input_axis)


func run_animation(input_axis):
	if !jumping:
		animated_sprite_2d.play("run")
		if input_axis < 1:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		
func get_input_axis():
	var input := Input.get_axis("left", "right")
	return input 

func sprint():
	sprinting = true
	movement_data = load("res://SprintMovement.tres")

func walk():
	sprinting = false
	movement_data = load("res://DefaultMovement.tres")
	
func double_jump():
	velocity.y = movement_data.jump_velocity * 0.85
