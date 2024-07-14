class_name _Entity extends Resource

@export var id:String
@export var name:String
@export var sprite:Texture2D

var type:String

var components:Dictionary

func _init(_type: String, json:Dictionary = {}) -> void:
	type = _type

	if json.has("position"): #TODO: Make this dynamic
		var position = json.get("position")
		components.get_or_add("position", Position.new(position.x, position.y))

	# TODO: Load json into components

func clone(json) -> _Entity:
	var entity = self.duplicate()

	if json.has("position"): #TODO: Make this dynamic
		var position = json.get("position")
		entity.components.get_or_add("position", Position.new(position.x, position.y))

	# TODO: Load json into components

	return entity
