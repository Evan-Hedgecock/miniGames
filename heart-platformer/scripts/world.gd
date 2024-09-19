extends Node2D


@onready var ground: CollisionPolygon2D = $Boundaries/Ground
@onready var polygon_2d: Polygon2D = $Boundaries/Ground/Polygon2D

func _ready() -> void:
		polygon_2d.polygon = ground.polygon
		RenderingServer.set_default_clear_color(Color.BLACK)
