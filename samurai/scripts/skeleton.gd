extends CharacterBody2D

var health = 100


func take_damage():
	health -= 100
	print("ouch!")
	
