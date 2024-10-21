extends CharacterBody2D

@onready var booster: Polygon2D = %Booster

const BOOSTER_STRENGTH = 5.0
const TERMINAL_VELOCITY = 200.0

func _physics_process(delta: float) -> void:
	process_movement()
	

func process_movement():
	var directionX := Input.get_axis("left", "right")
	var directionY := Input.get_axis("up", "down")
	var directionVector = Vector2(directionX, directionY)
	toggle_booster(directionVector)
	if directionX:
		velocity.x = move_toward(velocity.x, TERMINAL_VELOCITY * directionX, BOOSTER_STRENGTH)
	if directionY:
		velocity.y = move_toward(velocity.y, TERMINAL_VELOCITY * directionY, BOOSTER_STRENGTH)
		
	move_and_slide()
	
func toggle_booster(vector):
	if vector.x or vector.y:
		booster.visible = true
	else:
		booster.visible = false
