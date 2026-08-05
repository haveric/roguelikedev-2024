class_name Position extends _Component

var x:int = -1
var y:int = -1

func _init(json: Dictionary = {}) -> void:
	super(json, "position")

func parse_json(json: Dictionary = {}) -> void:
	if json.has("x"):
		x = json.x
	if json.has("y"):
		y = json.y

func move(xOffset: int, yOffset: int) -> void:
	x += xOffset
	y += yOffset

func distance_to(position) -> int:
	var dx: int = abs(position.x - x)
	var dy: int = abs(position.y - y)

	return max(dx, dy)

func is_at(_x: int, _y: int) -> bool:
	return x == _x && y == _y
