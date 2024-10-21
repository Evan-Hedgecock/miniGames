extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $"../CollisionShape2D"

@export var radius := 10
@export var color := Color.WHITE



func _draw() -> void:
	draw_circle(collision_shape_2d.position, radius, color)
