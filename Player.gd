extends KinematicBody2D

var moveSpeed : int = 300

var vel : Vector2 = Vector2()
var facingDir : Vector2 = Vector2()

onready var rayCast = $RayCast2D

func _physics_process(_delta):
	
	vel = Vector2()
	
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		facingDir = Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		vel.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		facingDir = Vector2(1, 0)
	
	vel = vel.normalized()
	
	var _mns = move_and_slide(vel * moveSpeed)
