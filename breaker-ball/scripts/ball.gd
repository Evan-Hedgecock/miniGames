extends RigidBody2D

@export var speed := 30
@export var bounciness := 50

func _ready() -> void:
	body_entered.connect(bounce.bind())
	
func bounce(body):
	print(body)
	
