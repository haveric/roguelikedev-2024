class_name _Component extends Resource

var id:String
var parent_entity: _Entity

func _init(_id: String, json: Dictionary = {}) -> void:
	id = _id

	if json:
		parse_json(json)

func parse_json(json: Dictionary = {}) -> void:
	print("Error: Not Implemented")
	return

func set_parent_entity(entity: _Entity) -> void:
	parent_entity = entity
