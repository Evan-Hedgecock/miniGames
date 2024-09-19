extends CharacterBody2D

@export var movement_data: PlayerMovementData
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var running
var jumping
var standing

func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("left", "right")
	manage_player_states()
	process_gravity(delta)
	process_movement(input_axis)
	process_jump()
	process_animations(input_axis)
	
	move_and_slide()

func process_gravity(delta):
	velocity.y += movement_data.gravity * delta

func process_movement(input_axis):
	if is_on_floor():
		if input_axis:
			acceleration(input_axis)
		else:
			friction()
	else:
		if input_axis:
			air_acceleration(input_axis)
		else:
			air_resistance()	
					
func air_resistance():
	velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance)

func air_acceleration(input_axis):
	velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.air_acceleration)

func friction():
	velocity.x = move_toward(velocity.x, 0, movement_data.friction)

func acceleration(input_axis):
	velocity.x = move_toward(velocity.x, input_axis * movement_data.speed, movement_data.acceleration)

func process_jump():
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = movement_data.jump_velocity
	if Input.is_action_just_released("jump") and velocity.y <= movement_data.jump_velocity / 2:
		velocity.y = movement_data.jump_velocity / 2

func process_animations(input_axis):
	if jumping:
			animated_sprite_2d.play("jump")
	else:
		if input_axis:	
			play_run()
			player_turn(input_axis)
		else:
			play_idle()

func play_run():
	animated_sprite_2d.play("run")
	
func play_idle():
	animated_sprite_2d.play("idle")
	
func player_turn(input_axis):
	if input_axis > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true

func manage_player_states():
	if is_on_floor():
		jumping = false
	else:
		jumping = true
