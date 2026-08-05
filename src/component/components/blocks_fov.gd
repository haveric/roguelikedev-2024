class_name BlocksFov extends _ExportableComponent

@export var blocks_fov: bool = true

func _init(json: Dictionary = {}) -> void:
	super(json, "blocks_fov")

func parse_json(json: Dictionary = {}) -> void:
	blocks_fov = json.blocks_fov
