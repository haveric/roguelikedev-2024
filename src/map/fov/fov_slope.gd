class_name FovSlope extends Node

var x: int
var y: int

func _init(_x: int, _y: int) -> void:
	x = _x
	y = _y

func greater(_x, _y) -> bool:
	return self.y * _x > self.x * _y

func greater_or_equal(_x, _y) -> bool:
	return self.y * _x >= self.x * _y

func less_or_equal(_x, _y) -> bool:
	return self.y * _x <= self.x * _y
