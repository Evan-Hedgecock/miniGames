extends Node2D
@onready var collision: CollisionPolygon2D = $Floor/CollisionPolygon2D
@onready var collision_color: Polygon2D = $Floor/Polygon2D

func _ready() -> void:
	collision_color.polygon = collision.polygon
