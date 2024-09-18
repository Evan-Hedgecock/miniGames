extends CharacterBody2D

@onready var player: CharacterBody2D = %Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 2000

func _physics_process(delta: float) -> void:
	var collider = get_last_slide_collision()
	if collider:
		if collider.get_collider() == player:
			movement(0)
			player.kill()
		else:
			movement(-delta)
	else:
		movement(delta)
	animate()
	move_and_slide()
	


func movement(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED * delta
	
func animate():
	if velocity.y > 0:
		animated_sprite.play("walk_down")
	elif velocity.x > 0:
		animated_sprite.play("walk_right")
	elif velocity.x < 0:
		animated_sprite.play("walk_left")
	elif velocity.y < 0:
		animated_sprite.play("walk_up")
	else:
		animated_sprite.play("idle")
		
