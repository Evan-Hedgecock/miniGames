extends Area2D

@onready var player: CharacterBody2D = %Player
var collider

# Get landing animation to play when entering landing zone.
func _process(delta: float) -> void:
	collider = get_overlapping_bodies()
	if collider == player:
		print("Landing!")
