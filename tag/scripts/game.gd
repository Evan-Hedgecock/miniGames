extends Node2D

var game_start = true
@onready var player: CharacterBody2D = %Player
@onready var dead_menu: BoxContainer = %DeadMenu
@onready var mobs: Node2D = $Mobs

func _process(delta: float) -> void:
	if game_start:
		start_game()
		game_start = !game_start
	else:
		# Show menu when dead
		if !player.alive:
			if dead_menu:
				dead_menu.visible = true
			if Input.is_action_just_pressed("click"):
				start_game()
				
func start_game():
	player.reset()
	dead_menu.visible = false
	player.alive = true
	for mob in mobs.get_children():
		mob.reset()
				
				
