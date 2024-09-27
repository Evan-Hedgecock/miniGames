extends PlayerState
class_name PlayerRun

func Enter():
	sprite.play("run")
	pass
	
func Update(delta: float):
	
	if Input.is_action_just_pressed("click"):
		Exit()
		change_state.emit(self, "Attacking") 
	
	if !player.is_on_floor():
		Exit()
		change_state.emit(self, "Falling")
		
	if Input.is_action_just_pressed("jump"):
		Exit()
		change_state.emit(self, "Jumping")
		
	player.ground_movement()		
	
	if player.velocity.x == 0:
		Exit()
		change_state.emit(self, "Idle")
	player.move_and_slide()

func Exit():
	sprite.stop()
