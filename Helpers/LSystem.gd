extends Object

class_name LSystem

var sentence : String
var ruleset

var generation : int

func _init(var axiom : String, var ruleset_):
	sentence = axiom
	ruleset = ruleset_
	generation = 0

func generate()->void:
	var nextGen = PoolStringArray()
	
	for c in sentence:
		var replace = c
		
		for rule in ruleset:
			var a = rule.getA()
			
			if a == c:
				replace = rule.getB()
		
		nextGen.append(replace)
	
	sentence = nextGen.join('')
	generation += 1

func getSentence()->String:
	return sentence

func getGeneration()->int:
	return generation
