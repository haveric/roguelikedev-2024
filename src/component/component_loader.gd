class_name ComponentLoader extends Node

var components_resource:ResourceGroup = preload("res://src/component/components.tres")

static var components:Array = []
static var component_map:Dictionary

func _ready() -> void:
	for path in components_resource.paths:
		var component = load(path).new()
		components.append(component)
		component_map.get_or_add(component.id, component)

static func create(name: String, json:Dictionary = {}) -> _Component:
	var component:_Component = null
	if component_map.has(name):
		component = component_map.get(name).clone(json)
	else:
		print("ERROR: Missing Component id: ", name)

	return component

static func load_from_json(parent_entity: _Entity, _components: Dictionary, json:Dictionary = {}) -> void:
	for component:_Component in components:
		if json.has(component.id):
			var json_to_add = json.get(component.id)
			var clone: _Component = component.duplicate()

			clone.set_parent_entity(parent_entity)
			clone.parse_json(json_to_add)
			_components.get_or_add(clone.id, clone)
