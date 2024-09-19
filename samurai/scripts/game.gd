extends Node2D

@onready var collision_polygon_2d: CollisionPolygon2D = %CollisionPolygon2D
@onready var polygon_2d: Polygon2D = %Polygon2D

func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
