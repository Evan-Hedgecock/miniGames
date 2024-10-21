extends PlayerState
class_name PlayerAttacking

@onready var attack_1: Timer = $Attack1
@onready var combo_buffer: Timer = $ComboBuffer
@onready var attack_2: Timer = $Attack2
@onready var attack_3: Timer = $Attack3
@onready var animations: AnimationPlayer = %HitBoxAnimations
@onready var attack_1_sound: AudioStreamPlayer2D = $"../../Attack1Sound"

var current_phase
enum phase {
	combo_buffer,
	attack1,
	attack2,
	attack3
}

var combo = 0

func Enter():
	attack_1_sound.play()
	combo = 0
	sprite.play("attack1")
	animations.play("attack1")
	
	attack_1.start()
	current_phase = phase.attack1
	
func Update(_delta: float):
	player.velocity.x = 0
	
#	If attack phase just ended then start combo buffer timer and change phase to combo buffer
	if (attack_1.time_left <= 0.15 and current_phase == phase.attack1 or
		attack_2.time_left <= 0.15 and current_phase == phase.attack2 or
		attack_3.time_left <= 0.15 and current_phase == phase.attack3):
			combo += 1
			combo_buffer.start()
			current_phase = phase.combo_buffer
		
#	If combo buffer times out then exit attack phase
	if (combo_buffer.time_left <= 0 and current_phase == phase.combo_buffer or
		combo >= 3 and current_phase == phase.combo_buffer):
			change_state.emit(self, "Idle")		
			Exit()
	
#	If in combo buffer phase check for more attack inputs
	if current_phase == phase.combo_buffer and Input.is_action_just_pressed("click"):
		attack_1_sound.play()
		if combo == 1:
			current_phase = phase.attack2
			attack_2.start()
			sprite.play("attack2")
			animations.play("attack2")
		if combo == 2:
			current_phase = phase.attack3
			attack_3.start()
			sprite.play("attack3")
			animations.play("attack3")
			
#	If at end of attack3 perform small dash
	if current_phase == phase.attack3 and attack_3.time_left < attack_3.wait_time:
		player.velocity.x = 100 * movement_data.facing_direction
		player.move_and_slide()
		player.velocity.x = 0
		
func Exit():
	sprite.stop()
