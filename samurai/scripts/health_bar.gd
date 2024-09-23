extends Control

@onready var health: ColorRect = $Health
@onready var damage: ColorRect = $Damage
var health_bar_width = 50

func _on_skeleton_damaged(health_percent: Variant) -> void:
	health.size.x = health_bar_width * health_percent
	

func _on_player_damaged(health_percent: Variant) -> void:
	print("Yay!")
	health.size.x = health_bar_width * health_percent
