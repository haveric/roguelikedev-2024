class_name Fov extends _Component

var explored:bool = false
var visible:bool = false

func _init(json: Dictionary = {}) -> void:
	super("fov", json)

func parse_json(json: Dictionary = {}) -> void:
	if json.has("explored"):
		explored = json.explored
	if json.has("visible"):
		visible = json.visible
