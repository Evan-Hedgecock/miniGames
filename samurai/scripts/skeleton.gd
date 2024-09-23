extends CharacterBody2D

@export var skeleton_data: SkeletonData

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = %Player
@onready var attack_timer: Timer = $AttackTimer
@onready var dash_delay: Timer = $DashDelay
@onready var dash_timer: Timer = $DashTimer
@onready var disengage_timer: Timer = $DisengageTimer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var hurting_timer: Timer = $HurtingTimer
@onready var dying_timer: Timer = $DyingTimer
@onready var health_bar: Control = $HealthBar
@onready var sword_location: Marker2D = $SwordLocation
@onready var sword: AnimatableBody2D = $SwordLocation/Sword

var health

signal was_attacked(damage)
signal killed
signal damaged(health_percent)
signal deal_damage(damage)
signal attack_signal
signal update_sword_damage(new_damage)

func _ready() -> void:
	was_attacked.connect(take_damage)
	killed.connect(get_killed)
	health = skeleton_data.max_health
	

func _physics_process(delta: float) -> void:
	#print("Engaged with player: " + str(skeleton_data.engaged))
	if !skeleton_data.dead:
		process_attacks()
		process_movement()
		process_animations()
		process_gravity(delta)
		move_and_slide()


func process_movement():
	var tracking_direction = track_player()
	var direction = tracking_direction / abs(tracking_direction)
	if skeleton_data.dashing:
		dash(direction)
	if skeleton_data.engaged and !skeleton_data.hurting:
		stop_movement()
		return
	if skeleton_data.can_detect_player:
		engage_player(tracking_direction)
	else:
		stop_movement()

func process_attacks():
	# Once engaging player can attack
	if skeleton_data.engaging_player and !skeleton_data.hurting:
		attack_start()
		

func flip_player():
	if skeleton_data.facing_direction == 1:
		animated_sprite.flip_h = false
		sword_location.rotation_degrees = 0
		
	elif skeleton_data.facing_direction == -1:
		animated_sprite.flip_h = true
		sword_location.rotation_degrees = 180
		

func animate_attack():
	var engaged = skeleton_data.engaged
	if engaged:
		if skeleton_data.can_dash and abs(track_player()) > skeleton_data.attack_range:
			animated_sprite.play("attack2")
		else:
			animated_sprite.play("attack1")
	return engaged

func process_animations():
	flip_player()
	if skeleton_data.hurting:
		animated_sprite.play("hurt")
		return
	if animate_attack():
		return
	if skeleton_data.walking:
		animated_sprite.play("walk")
	elif skeleton_data.idling:
		animated_sprite.play("idle")

func process_gravity(delta):
	if !is_on_floor():
		velocity.y += skeleton_data.gravity * delta

func move_right():
	skeleton_data.walking = true
	skeleton_data.idling = false
	skeleton_data.facing_direction = 1
	velocity.x = move_toward(velocity.x, skeleton_data.speed, skeleton_data.acceleration)

func move_left():
	skeleton_data.walking = true
	skeleton_data.idling = false
	skeleton_data.facing_direction = -1
	velocity.x = move_toward(velocity.x, skeleton_data.speed * -1, skeleton_data.acceleration)

func stop_movement():
	skeleton_data.walking = false
	skeleton_data.idling = true
	velocity.x = 0
	
func track_player():
	var tracking_direction = player.global_position.x - global_position.x
	return tracking_direction

func detect_player():
	skeleton_data.can_detect_player = true

func ignore_player():
	skeleton_data.can_detect_player = false
	
# Start attack sequence, attack will last for total attack timer duration
func attack_start():
	attack_timer.start()
	dash_delay.start()
	skeleton_data.engaged = true
	skeleton_data.engaging_player = false
	
func attack_stop():
	skeleton_data.engaged = false

func start_dash():
	if abs(track_player()) < skeleton_data.attack_range or !skeleton_data.can_dash:
		return
	dash_timer.start()
	skeleton_data.dashing = true

func dash(direction):
	velocity.x = skeleton_data.dash_distance * direction
	move_and_slide()

func stop_dash():
	attack_signal.emit()
	skeleton_data.dashing = false
	skeleton_data.disengaging = true
	skeleton_data.engaged = false
	skeleton_data.can_dash = false
	dash_cooldown.start()
	
# Either move to engage player or do engage them
func engage_player(tracking_direction):
	var range = 0
	if skeleton_data.can_dash:
		range = skeleton_data.dash_range
	else:
		range = skeleton_data.attack_range
	if tracking_direction > range:
		move_right()
	elif tracking_direction < range * -1:
		move_left()
	else:
		skeleton_data.engaging_player = true
		
func take_damage(damage):
	if !skeleton_data.dead:
		health -= damage
		hurt()
		
		if health <= 0:
			killed.emit()

func hurt():
	var health_percent = float(health) / float(skeleton_data.max_health)
	damaged.emit(health_percent)
	hurting_timer.start()
	skeleton_data.hurting = true
	if !skeleton_data.dashing:
		knockback()

func knockback():
	var direction = abs(track_player()) / track_player()
	velocity.x = skeleton_data.knockback * -direction
	move_and_slide()

func get_killed():
	skeleton_data.dead = true
	dying_timer.start()
	animated_sprite.play("dying")
	
func _on_detection_range_body_entered(body: Node2D) -> void:
	detect_player()

func _on_detection_range_body_exited(body: Node2D) -> void:
	ignore_player()

func _on_attack_timer_timeout() -> void:
	attack_stop()

func _on_dash_delay_timeout() -> void:
	start_dash()

func _on_dash_timer_timeout() -> void:
	stop_dash()

func _on_dash_cooldown_timeout() -> void:
	skeleton_data.can_dash = true

#func _on_sword_attack_signal(damage: Variant) -> void:
	#print("damaged")


func _on_player_deal_damage(damage: Variant) -> void:
	take_damage(damage)

func _on_hurting_timer_timeout() -> void:
	skeleton_data.hurting = false

func _on_dying_timer_timeout() -> void:
	animated_sprite.play("dead")
	health_bar.visible = false
	
