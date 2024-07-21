class_name _Entity extends Resource

@export_category("Entity")
@export var id:String
@export var name:String
@export var sprite:Texture2D

@export_category("Components")
@export var default_components: Array[_ExportableComponent]

var type:String
var components:Dictionary

var map_tile

func _init(_type: String, json:Dictionary = {}) -> void:
	type = _type

	load_components(json)

func clone(json) -> _Entity:
	var entity: _Entity = self.duplicate()

	entity.load_components(json)

	return entity

func load_components(json: Dictionary = {}) -> void:
	for component in default_components:
		var clone = component.duplicate()
		clone.set_parent_entity(self)
		components.get_or_add(clone.id, clone)

	ComponentLoader.load_from_json(self, components, json)

func set_map_tile(tile: MapTile) -> void:
	map_tile = tile
