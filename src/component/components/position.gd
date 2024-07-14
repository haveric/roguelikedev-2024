class_name Position extends _Component

var x:int = -1
var y:int = -1

func _init(_x: int, _y: int) -> void:
	super("position")
	x = _x
	y = _y

func move(xOffset: int, yOffset: int) -> void:
	x += xOffset
	y += yOffset
