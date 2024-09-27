extends PlayerState
class_name PlayerFalling

func Enter():
	sprite.play("falling")

func Update(_delta: float):
	if player.is_on_floor():
		Exit()
		change_state.emit(self, "Idle")
		
	player.air_movement()
	player.flip_sprite()

func Exit():
	pass
