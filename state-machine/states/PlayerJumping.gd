extends PlayerState
class_name PlayerJumping

@onready var jump_timer: Timer = $JumpTimer

func Enter():
	player.velocity.y -= movement_data.jump_velocity
	sprite.play("jump")
	jump_timer.start()
	player.move_and_slide()
	

func Update(_delta: float):
	if player.is_on_floor():
		Exit()
		change_state.emit(self, "Idle")
	
	if player.velocity.y > 0 and jump_timer.time_left > 0:
		Exit()
		change_state.emit(self, "Falling")

	if Input.is_action_just_released("jump"):
		player.velocity.y /= 1.5	
		
	player.air_movement()
	
	player.flip_sprite()
	
func Exit():
	sprite.stop()
