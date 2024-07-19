class_name _Action extends Node

var entity: _Entity

func _init(_entity: _Entity) -> void:
	entity = _entity

func perform(map: Map) -> _Action:
	print("Error: Not Implemented")
	return null
