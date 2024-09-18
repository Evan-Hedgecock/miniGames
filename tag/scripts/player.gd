extends CharacterBody2D

const SPEED = 8000
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var alive = true
var health = 10000
const START_POSITION = Vector2(0, 0)


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if alive:
		movement(delta)
		animate()
	else:
		animate()
		
func movement(delta):
	# Move player on user input
	var direction
	if name == "Player":
		direction = Input.get_vector("left", "right", "up", "down")
	else:
		direction = Input.get_vector("left2", "right2", "up2", "down2")
	velocity = SPEED * direction * delta
	move_and_slide()


func animate():
	if velocity.x > 0:
		animated_sprite.play("walk_right")
	elif velocity.x < 0:
		animated_sprite.play("walk_left")
	elif velocity.y > 0:
		animated_sprite.play("walk_down")
	elif velocity.y < 0:
		animated_sprite.play("walk_up")
	else:
		animated_sprite.play("idle")
		
func kill():
	if alive:
		alive = !alive
		
func reset():
	set_global_position(START_POSITION)
