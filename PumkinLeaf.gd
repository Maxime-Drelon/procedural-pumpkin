extends Area2D

export var growthSpeed : float = 0.1
export var growthStep : float = 0.15

export var maxSize : float
export var inverted : bool = false

export var tiltAngle : int = -30
export var tiltStep : float = 0.1

export var bumped : bool = false
export var reachedMaxAngle : bool = false

onready var growthTimer : Timer = get_node("Timer")

func _ready():
	growthTimer.wait_time = growthSpeed
	growthTimer.start()

func _physics_process(_delta):
	if abs(rotation_degrees) + 0.1 >= abs(tiltAngle) and !reachedMaxAngle:
		reachedMaxAngle = true
	
	if abs(rotation_degrees) - 1 <= 0.0:
		reachedMaxAngle = false
	
	if bumped and !reachedMaxAngle or !reachedMaxAngle and abs(rotation_degrees) - 1 >= 0.0:
		rotation_degrees = lerp(rotation_degrees, tiltAngle, tiltStep)
	
	if !bumped and reachedMaxAngle:
		rotation_degrees = lerp(rotation_degrees, 0, tiltStep)

func invert():
	inverted = true
	tiltAngle = -tiltAngle
	scale.x = -scale.x

func grow():
	if scale.y < maxSize:
		scale.y += growthStep
		if (inverted):
			scale.x -= growthStep
		else:
			scale.x += growthStep
	else:
		growthTimer.stop()

func _on_Timer_timeout():
	grow()

func _on_PumpkinLeaf_body_entered(_body):
	if bumped == false:
		bumped = true
		reachedMaxAngle = false

func _on_PumpkinLeaf_body_exited(_body):
	bumped = false
