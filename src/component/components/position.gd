class_name Position extends _Component

var x:int = -1
var y:int = -1

func _init(json: Dictionary = {}) -> void:
	super("position", json)

func parse_json(json: Dictionary = {}) -> void:
	if json.has("x"):
		x = json.x
	if json.has("y"):
		y = json.y

func move(xOffset: int, yOffset: int) -> void:
	x += xOffset
	y += yOffset
