extends Object

class_name Rule

var a : String
var b : String

func _init(var a_ : String, var b_ : String):
	a = a_
	b = b_

func getA()->String:
	return a

func getB()->String:
	return b
