extends PlayerState
class_name PlayerFalling

func Enter():
	sprite.play("falling")

func Update(_delta: float):
	if Input.is_action_just_pressed("click"):
		Exit()
		change_state.emit(self, "AirAttack")
	
	if player.is_on_floor():
		Exit()
		change_state.emit(self, "Idle")
		
	player.air_movement()
	player.flip_sprite()

func Exit():
	sprite.stop()
