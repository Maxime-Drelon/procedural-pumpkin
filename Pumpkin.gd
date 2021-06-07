extends Node2D

export var generations : int = 3
export var length : int = 10
export var angleMin : int = 35
export var angleMax : int = 50
export var direction : Vector2 = Vector2(0, -1)
export var randAngle : bool = true

var pos : Vector2 = Vector2(0, 0)
var poses : Array = Array()
var leafs : Array = Array()

var lsys : LSystem

var angle : float = angleMin
var sentenceIndex : int = 0

var points : Array = Array()
var pointsIndex : int = 0

onready var growthTimer : Timer = get_node("Timer")
onready var drawingTimer : Timer = get_node("Timer2")

onready var tileMap : TileMap = get_node("TileMap")

onready var leaf : PackedScene = preload("res://PumkinLeaf.tscn")

func _ready():
	randomize()

func draw_vine_bit():
	if pointsIndex >= points.size():
		pointsIndex = 0
		move_vine_base()
		drawingTimer.stop()
		growthTimer.start()
		return
	
	var item : Vector2 = points[pointsIndex]
	
	tileMap.set_cell(int(item[0]) - 1, int(item[1]), 0)
	tileMap.set_cell(int(item[0]), int(item[1]), 1)
	tileMap.set_cell(int(item[0]) + 1, int(item[1]), 2)
	
	pointsIndex += 1

func draw_vines():
	var next_pos : Vector2 = pos + (direction * length)
	
	points = BresenhamLine.plotline(int(pos.x), int(pos.y), int(next_pos.x), int(next_pos.y))
	
	growthTimer.stop()
	
	if sentenceIndex % 2 == 0:
		var localCellPosition = tileMap.map_to_world(pos)
		var globalCellPosition = tileMap.to_global(localCellPosition)
		
		var scale : float = rand_range(3, 5.5)
		var new_leaf : Node = leaf.instance()
		
		new_leaf.maxSize = scale
		
		globalCellPosition.x = globalCellPosition.x - global_position.x
		globalCellPosition.y = globalCellPosition.y - global_position.y
		
		new_leaf.global_position = globalCellPosition
		
		if leafs.size() % 2 == 0 and leafs.size() > 0:
			new_leaf.invert()
		
		leafs.append(new_leaf)
		add_child(new_leaf)
	
	drawingTimer.start()

func _on_Timer2_timeout():
	draw_vine_bit()

func draw_fruit():
	# Temporary will be replaced with an instance of PumpkinFruit
	tileMap.set_cell(int(pos.x), int(pos.y), 3)
	tileMap.set_cell(int(pos.x + 1), int(pos.y), 3)
	tileMap.set_cell(int(pos.x + 2), int(pos.y), 3)
	tileMap.set_cell(int(pos.x + 3), int(pos.y), 3)
	
	tileMap.set_cell(int(pos.x), int(pos.y + 1), 3)
	tileMap.set_cell(int(pos.x + 1), int(pos.y + 1), 4)
	tileMap.set_cell(int(pos.x + 2), int(pos.y + 1), 4)
	tileMap.set_cell(int(pos.x + 3), int(pos.y + 1), 3)

	tileMap.set_cell(int(pos.x), int(pos.y + 2), 5)
	tileMap.set_cell(int(pos.x + 1), int(pos.y + 2), 5)
	tileMap.set_cell(int(pos.x + 2), int(pos.y + 2), 5)
	tileMap.set_cell(int(pos.x + 3), int(pos.y + 2), 5)
	
	tileMap.set_cell(int(pos.x), int(pos.y + 3), 5)
	tileMap.set_cell(int(pos.x + 1), int(pos.y + 3), 5)
	tileMap.set_cell(int(pos.x + 2), int(pos.y + 3), 5)
	tileMap.set_cell(int(pos.x + 3), int(pos.y + 3), 5)

func move_vine_base():
	pos = pos + (direction * length)

func rotate_vine(var invert : bool):
	if invert:
		direction = direction.rotated(deg2rad(-angle))
	else:
		direction = direction.rotated(deg2rad(angle))

func save_current_pos():
	poses.push_front(pos)

func load_previous_pos():
	pos = poses.pop_front()

func grow():
	var sentence : String = lsys.getSentence()
	var instruction : String =  sentence[sentenceIndex]
	
	if lsys.getGeneration() >= generations:
		$Rules/Button.disabled = !$Rules/Button.disabled
		growthTimer.stop()
		return
	
	sentenceIndex += 1
	
	if randAngle:
		angle = rand_range(angleMin, angleMax)
	
	match instruction:
		'F':
			draw_vines()
		'O':
			draw_fruit()
		'+':
			rotate_vine(false)
		'-':
			rotate_vine(true)
		'[':
			save_current_pos()
		']':
			load_previous_pos()
	
	if sentenceIndex >= sentence.length():
		sentenceIndex = 0
		lsys.generate()

func _on_Timer_timeout():
	grow()

func get_rules():
	var rules = []
	var label1 = $Rules/Rule1.text
	var label2 = $Rules/Rule2.text
	
	label1 = label1.split('->')
	label2 = label2.split('->')
	
	if label1.size() > 1:
		rules.append(Rule.new(label1[0], label1[1]))
	if label2.size() > 1:
		rules.append(Rule.new(label2[0], label2[1]))
	
	return rules

func _on_Button_pressed():
	var rules = get_rules()
	
	$Rules/Button.disabled = !$Rules/Button.disabled
	lsys = LSystem.new($Rules/FirstGeneration.text, rules)
	pos = Vector2(0, 0)
	direction = Vector2(0, -1)
	sentenceIndex = 0
	pointsIndex = 0
	poses.clear()
	for _leaf in leafs:
		_leaf.free()
	leafs.clear()
	tileMap.clear()
	growthTimer.start()
