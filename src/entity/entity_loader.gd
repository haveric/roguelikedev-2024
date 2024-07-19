class_name EntityLoader extends Node

var entities_resource:ResourceGroup = preload("res://data/entities.tres")
var entities:Array[_Entity] = []
static var entity_map:Dictionary

const entity_types = {
	"actor": preload("res://src/entity/actor.gd"),
	"tile": preload("res://src/entity/tile.gd"),
	"item": preload("res://src/entity/item.gd")
}

func _ready() -> void:
	entities_resource.load_all_into(entities)
	for entity:_Entity in entities:
		entity_map.get_or_add(entity.id, entity)

static func create(name: String, json:Dictionary = {}) -> _Entity:
	var entity:_Entity = null
	if entity_map.has(name):
		entity = entity_map.get(name).clone(json)

	else:
		print("ERROR: Missing Entity id: ", name)

	return entity
