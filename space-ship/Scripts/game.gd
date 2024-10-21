extends Node2D
@onready var background_collision: CollisionPolygon2D = %BackgroundCollision
@onready var background_color: Polygon2D = %BackgroundColor
@onready var background: Area2D = $Background
@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	background_color.polygon = background_collision.polygon
	
func _process(delta: float) -> void:
	background.global_position = player.global_position
