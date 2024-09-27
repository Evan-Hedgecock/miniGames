extends CharacterBody2D

@export var movement_data : PlayerMovementData
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fsm: FiniteStateMachine = $FiniteStateMachine


func _process(delta: float) -> void:
	flip_sprite()

func _physics_process(delta: float) -> void:
	process_gravity(delta)
	move_and_slide()
	
func process_gravity(delta):
	if !is_on_floor():
		velocity.y += movement_data.gravity * delta

func ground_movement():
	var input_axis = get_input_axis()
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration)
	else:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.friction)


func air_movement():
	var input_axis = get_input_axis()
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.air_speed * input_axis, movement_data.air_acceleration)
		move_and_slide()
		
func flip_sprite():
	var input_axis = get_input_axis()
	if input_axis < 0:
		movement_data.facing_direction = input_axis
	elif input_axis > 0:
		movement_data.facing_direction = input_axis
	scale.x = scale.y * movement_data.facing_direction

func get_input_axis():
	return Input.get_axis("left", "right")
	
func stop_on_landing():
	var input_axis = get_input_axis()
	if input_axis == 0:
		velocity.x = 0
	
