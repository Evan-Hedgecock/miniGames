extends CharacterBody2D

@export var move_speed := 40

var input_axis : int

func _physics_process(delta: float) -> void:
	input_axis = Input.get_axis("left", "right")
	if input_axis != 0:
		velocity.x = move_speed * input_axis
		move_and_collide(Vector2(velocity.x, 0))
