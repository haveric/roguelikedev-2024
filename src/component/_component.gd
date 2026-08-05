class_name _Component extends Resource

var base_type: String
var type: String
var parent_entity: _Entity

func _init(json: Dictionary = {}, _base_type: String = "component", _type: String = "") -> void:
	base_type = _base_type

	if _type.is_empty():
		type = base_type
	else:
		type = _type

	if !json.is_empty():
		parse_json(json)

func parse_json(json: Dictionary = {}) -> void:
	print("Error: Not Implemented")

func setup_defaults() -> void:
	pass

func set_parent_entity(entity: _Entity) -> void:
	parent_entity = entity
	setup_defaults()
