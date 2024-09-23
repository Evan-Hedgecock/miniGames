extends AnimatableBody2D
@onready var hit_box: Area2D = %HitBox

var direction = -1
var damage = 35

signal deal_damage(damage, body)

func set_damage(new_damage):
	damage = new_damage

func attack():
	var attacking = hit_box.get_overlapping_bodies()
	for body in attacking:
		print("Sword attacked!")
		deal_damage.emit(damage, body)
			
func flip_sword(direction):
	var position = 54 * direction
	hit_box.get_child(0).position.x += position

func _on_player_attack_signal() -> void:
	attack()

func _on_player_change_direction(direction) -> void:
	flip_sword(direction)

func _on_skeleton_attack_signal() -> void:
	attack()

func _on_skeleton_update_sword_damage(new_damage: Variant) -> void:
	set_damage(new_damage)
