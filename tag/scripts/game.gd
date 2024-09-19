extends Node2D

var game_start = true
@onready var player: CharacterBody2D = %Player
@onready var dead_menu: Label = %DeadMenu
@onready var mobs: Node2D = $Mobs

func _process(delta: float) -> void:
	if game_start:
		start_game()
		game_start = !game_start
	else:
		if !player.alive:
			dead_menu.visible = true
		# Show menu when dead
		if Input.is_action_just_pressed("click"):
				start_game()
				
func start_game():
	player.reset()
	dead_menu.visible = false
	for mob in mobs.get_children():
		mob.reset()
	player.alive = true
				
				
