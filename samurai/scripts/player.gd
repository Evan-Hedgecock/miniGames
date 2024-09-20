extends CharacterBody2D

@export var movement_data: PlayerMovementData
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var double_jump_timer: Timer = %DoubleJumpTimer
@onready var attack_timer: Timer = %AttackTimer
@onready var sword: AnimatableBody2D = %Sword
@onready var sword_location: Marker2D = %SwordLocation

const MAX_COYOTE_FRAMES = 2

# Player states: GO TO manage_player_states() to update
var sprinting
var jumping
var can_jump
var can_double_jump
var double_jumping
var can_coyote_jump
var coyote_frames = MAX_COYOTE_FRAMES
var just_left_ledge
var landed
var attacking


signal attack_signal
signal change_direction(direction)

func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("left", "right")
	# Left ledge gets passed true one single time
	manage_player_states(input_axis)
	process_gravity(delta)
	process_movement(input_axis)
	process_jump()
	process_animations(input_axis)
	manage_player_direction(input_axis)
	# This checks if the player landed or left the edge after moving
	var before_move = is_on_floor()
	move_and_slide()
		
	just_left_ledge = before_move != is_on_floor() and velocity.y > 0
	landed = before_move != is_on_floor() and velocity.y == 0
	
func process_gravity(delta):
	velocity.y += movement_data.gravity * delta

func process_movement(input_axis):
	set_sprint()
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
	jump()
	coyote_jump()
	double_jump()
	short_jump()

# If not already jumping, let player jump
func jump():
	if !jumping and Input.is_action_just_pressed("jump"):
		velocity.y = movement_data.jump_velocity

# Reduces jump height if jump is released early
func short_jump():
	if Input.is_action_just_released("jump") and velocity.y <= movement_data.jump_velocity / 2:
		velocity.y = movement_data.jump_velocity / 2

# If player can double jump and is already jumping, let player jump
func double_jump():
	if can_double_jump and jumping and !can_coyote_jump and Input.is_action_just_pressed("jump"):
		velocity.y = movement_data.jump_velocity * movement_data.double_jump
		double_jumping = true
		double_jump_timer.start()
		
func coyote_jump():
	if can_coyote_jump and Input.is_action_just_pressed("jump"):
		velocity.y = movement_data.jump_velocity
		
func process_animations(input_axis):
	if attacking:
		play_attack()
		return
	if jumping:
		if double_jumping:
			play_double_jump()
		else:
			play_jump()
	if is_on_floor() and abs(velocity.x) > 0:
		play_run()
	if is_on_floor() and velocity.x == 0:
		play_idle()

func play_run():
	animated_sprite_2d.play("run")
	
func play_idle():
	animated_sprite_2d.play("idle")

func play_jump():
	animated_sprite_2d.play("jump")

func play_double_jump():
	animated_sprite_2d.play("double_jump")
	
# Flip player sprite in direction of input
func flip_player(input_axis):
	if input_axis > 0:
		animated_sprite_2d.flip_h = false	
	else:
		animated_sprite_2d.flip_h = true

func manage_player_states(input_axis):
	if input_axis:
		flip_player(input_axis)
	#position_sword()
	if is_on_floor():
		reset_jump()
	else:
		if just_left_ledge:
			can_coyote_jump = true
		else:
			# After leaving ledge, decide how many frames to allow coyote jump
			if coyote_frames <= 0:
				can_coyote_jump = false
			else:
				coyote_frames -= 1
			if !can_coyote_jump:
				jumping = true
		if double_jumping:
			can_double_jump = false
			
	if double_jump_timer.time_left <= 0:
		double_jumping = false
		
	if Input.is_action_just_pressed("sprint"):
		sprinting = true
		
	elif Input.is_action_just_released("sprint"):
		sprinting = false
		
	if Input.is_action_just_pressed("click"):
		start_attack()
	if attack_timer.time_left <= 0:
		end_attack()

func set_sprint():
	if sprinting:
		set_sprint_values()
	else:
		set_walk_values()		
func reset_jump():
	coyote_frames = MAX_COYOTE_FRAMES
	can_jump = true
	jumping = false
	can_double_jump = true
	double_jumping = false

func play_attack():
	animated_sprite_2d.play("attack")

func start_attack():
	attacking = true
	attack_timer.start()
	attack_signal.emit()
	
func end_attack():
	attacking = false
	reset_connections(attack_signal.get_connections())
	
func reset_connections(connections):
	for callable in connections:
		var c = callable["callable"]
		attack_signal.disconnect(c)
		attack_signal.connect(c)
		
func position_sword():
	if movement_data.facing_direction == 1:
		sword_location.position = Vector2(22, 43)
		sword_location.rotation = 0
	elif movement_data.facing_direction == -1:
		sword_location.position = Vector2(-40, 43)
		sword_location.rotation = 0
	else:
		print("Uh oh! movement_data.facing_direction returned an unexpected value: func position_sword()")
		
#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#pass # Replace with function body.

func manage_player_direction(input_axis):
	if movement_data.facing_direction != input_axis and input_axis != 0:
		movement_data.facing_direction = input_axis
		change_direction.emit(movement_data.facing_direction)

func set_sprint_values():
	movement_data.speed = 220
	movement_data.jump_velocity = -330
	movement_data.acceleration = 80
	movement_data.friction = 40
	movement_data.air_acceleration = 40

func set_walk_values():
	movement_data.speed = 200
	movement_data.jump_velocity = -320
	movement_data.acceleration = 60
	movement_data.friction = 30
	movement_data.air_acceleration = 30
