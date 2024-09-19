extends CharacterBody2D

@onready var player: CharacterBody2D = %Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 2000
var rng = RandomNumberGenerator.new()


func _physics_process(delta: float) -> void:
	var collider = get_last_slide_collision()
	if collider:
		if collider.get_collider() == player:
			movement(0)
			if player.alive:
				player.kill()
				print("killed player")
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
		
func reset():
	var randomizing = true
	while randomizing:
		var startX = rng.randi_range(-250, 250)
		var startY = rng.randi_range(-250, 250)
		if startX >= 12 || startX <= -12 && startY >= 12 || startY <= -12:
			randomizing = false
			var start_position = Vector2(startX, startY)
			set_global_position(start_position)
