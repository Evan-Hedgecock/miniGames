extends PlayerState
class_name PlayerIdle

func Enter():
	sprite.play("idle")
	pass
	
func Update(_delta: float):
	player.stop_on_landing()
	
	if Input.is_action_just_pressed("click"):
		Exit()
		change_state.emit(self, "Attacking") 
	
	if !player.is_on_floor():
		Exit()
		change_state.emit(self, "Falling")
	
	if Input.is_action_just_pressed("jump"):
		Exit()
		change_state.emit(self, "Jumping")

	if Input.get_axis("left", "right"):
		Exit()
		change_state.emit(self, "Run")

func Exit():
	sprite.stop()
