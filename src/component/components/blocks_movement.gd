class_name BlocksMovement extends _ExportableComponent

@export var blocks_movement: bool = true

func _init(json: Dictionary = {}) -> void:
	super("blocks_movement", json)

func parse_json(json: Dictionary = {}) -> void:
	blocks_movement = json.blocks_movement
