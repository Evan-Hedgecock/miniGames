extends Area2D
class_name Hurtbox

func _init() -> void:
	collision_layer = 0
	collision_mask = 2
	
func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return
		
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
