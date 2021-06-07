extends Object

class_name BresenhamLine

static func plotLineLow(x0 : int, y0 : int, x1 : int, y1 : int)->Array:
	var points = Array()
	
	var dx = x1 - x0
	var dy = y1 - y0
	var yi = 1
	
	if dy < 0:
		yi = -1
		dy = -dy
	
	var D = (2 * dy) - dx
	var y = y0
	
	for x in range(x0, x1 + 1):
		points.append(Vector2(x, y))
		if D > 0:
			y = y + yi
			D = D + (2 * (dy - dx))
		else:
			D = D + (2 * dy)
	
	return points

static func plotLineHigh(x0 : int, y0 : int, x1 : int, y1 : int)->Array:
	var points = Array()

	var dx = x1 - x0
	var dy = y1 - y0
	var xi = 1
	
	if dx < 0:
		xi = -1
		dx = -dx
	
	var D = (2 * dx) - dy
	var x = x0
	
	for y in range(y0, y1 + 1):
		points.append(Vector2(x, y))
		if D > 0:
			x = x + xi
			D = D + (2 * (dx - dy))
		else:
			D = D + (2 * dx)
	
	return points

static func plotline(x0 : int, y0 : int, x1 : int, y1 : int)->Array:
	var points
	
	if abs(y1 - y0) < abs(x1 - x0):
		if x0 > x1:
			points = plotLineLow(x1, y1, x0, y0)
			points.invert()
		else:
			points = plotLineLow(x0, y0, x1, y1)
	else:
		if y0 > y1:
			points = plotLineHigh(x1, y1, x0, y0)
			points.invert()
		else:
			points = plotLineHigh(x0, y0, x1, y1)
	
	return points
