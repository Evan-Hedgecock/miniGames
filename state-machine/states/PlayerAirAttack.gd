extends PlayerState
class_name AirAttack

@onready var animations: AnimationPlayer = %HitBoxAnimations
@onready var combo_buffer: Timer = $ComboBuffer
@onready var combo_dash: Timer = $ComboDash

@export var combo_dash_velocity = 120

var airborne
var did_combo

func Enter():
	did_combo = false
	airborne = true
	player.velocity.y = movement_data.air_attack_velocity
	player.velocity.x = 0
	player.move_and_slide()
	sprite.speed_scale = 0.8
	animations.play("air_attack")

func Update(_delta: float):
	if player.is_on_floor() and airborne == true:
		animations.play("air_attack_landing")
		combo_buffer.start()
		airborne = false
		
	if airborne == false and combo_buffer.time_left > 0 and Input.is_action_just_pressed("click"):
		did_combo = true
		combo_dash.start()
		animations.play("RESET")	
		sprite.play("attack3")
		animations.play("attack3")
		var input_axis = player.get_input_axis()
		if input_axis != 0:
			player.velocity.x = combo_dash_velocity * input_axis
		else:
			player.velocity.x = combo_dash_velocity * movement_data.facing_direction
		player.move_and_slide()
		
	if !airborne and ((did_combo and combo_dash.time_left <= 0) or (!did_combo and combo_buffer.time_left <= 0)):
		Exit()
		change_state.emit(self, "Idle")

func Exit():
	animations.play("RESET")
	sprite.speed_scale = 1
	sprite.stop()
