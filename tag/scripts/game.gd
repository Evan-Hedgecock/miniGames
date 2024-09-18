extends Node2D

var game_start = true
@onready var player: CharacterBody2D = %Player
@onready var dead_menu: BoxContainer = %DeadMenu

func _process(delta: float) -> void:
	if game_start:
		
		game_start = !game_start
	if player.alive:
		print("You're alive!")
		if dead_menu:
			dead_menu.visible = false
	else:
		# Show menu when dead
		if dead_menu:
			dead_menu.visible = true
			if Input.is_action_just_pressed("click"):
				pass
				
