class_name SkeletonData
extends Resource

### Physical related variables
@export var max_health = 100.0
@export var speed = 60.0
@export var acceleration = 30.0
@export var gravity = 840.0
@export var attack_range = 30.0
@export var dash_distance = 225.0
@export var dash_range = 80.0
@export var knockback = 300


### Enemy state and phase variables
@export var can_detect_player = false
@export var walking = false
@export var idling = true
@export var attacking = false
@export var hurting = false
@export var engaging_player = false
@export var engaged = false
@export var dashing = false
@export var facing_direction = 1
@export var disengaging = false
@export var can_dash = true
@export var dead = false
