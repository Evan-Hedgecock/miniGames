extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0
const ACCELERATION = 100
const FRICTION = 100

var jumping = false
var landing = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var landing_zone: CollisionPolygon2D = %LandingZone


func _physics_process(delta: float) -> void:
	process_gravity(delta)
	process_jump()
	process_movement(delta)
	process_animations()
	
	move_and_slide()
	
func process_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func process_jump():
	if is_on_floor():
		jumping = false
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			jumping = true
		
func process_movement(delta):
	var input_axis = get_input_axis()
	if input_axis:
		accelerate(input_axis)
	else:
		friction()
		
func process_animations():
	var input_axis = get_input_axis()
	# Use landing_zone.gd to trigger landing animation
	if landing:
		animated_sprite.play("jump_land")
		landing = false
	else:
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
	velocity.x = move_toward(velocity.x, axis * SPEED, ACCELERATION)
		
func friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func run():
	if !jumping:
		animated_sprite.play("run")
