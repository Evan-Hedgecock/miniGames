extends AnimatableBody2D
@onready var hit_box: Area2D = %HitBox

var direction = -1
var damage = 10


func attack():
	if hit_box.has_overlapping_bodies():
		print("Hitting!")
		print(hit_box.get_overlapping_bodies())
		
		
### THIS IS A VERY FRAGILE FUNCTION PLEASE READ
### All of the positions were brute forced trial and error. It seemed easier than an algorithm for it
### It probably isn't. But if you try to change it at least save this one.
### ALSO IMPORTANT: These are set for the current sword hitbox. Don't change that either		
func flip_sword(direction):
	## If the input direction is "left" then move hitbox children to the left side of player
	if direction == -1:
		# This is the "initial" move distance, I don't remember why I did it this way...
		var position = 13
		## Loop through each bubble in the hitbox group for player sword
		## and move according to the direction
		for bubble in hit_box.get_children():
			bubble.position.x -= position
			# After rectangle
			if position == 13:
				# Move further
				position += 7
				# And then move this far for every circle
			position += 17
	## If the input directino is "right", then move hitbox children to the right side of player
	elif direction == 1:
		# This is the "initial" move distance, I don't remember why I did it this way...
		var position = -13
		## Loop through each bubble in the hitbox group for player sword
		## and move according to direction
		for bubble in hit_box.get_children():
			bubble.position.x -= position
			# After rectangle
			if position == -13:
				# Move further
				position -= 7
			# And then move this for for every circle
			position -= 17

func _on_player_attack_signal() -> void:
	attack()


func _on_player_change_direction(direction) -> void:
	flip_sword(direction)
