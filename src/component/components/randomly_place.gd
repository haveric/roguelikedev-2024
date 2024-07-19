class_name RandomlyPlace extends _ExportableComponent

var tile_size = 128

var x_offset: int
var y_offset: int

func _init(json: Dictionary = {}) -> void:
	super("randomly_place", json)

func parse_json(json: Dictionary = {}) -> void:
	if json.has("randomly_place"):
		x_offset = json.get("randomly_place").x_offset
		y_offset = json.get("randomly_place").y_offset

func set_parent_entity(entity: _Entity) -> void:
	super(entity)

	if parent_entity && parent_entity.sprite:
		var sprite_size: Vector2 = parent_entity.sprite.get_size()
		x_offset = randi_range(0, tile_size - sprite_size.x)
		y_offset = randi_range(0, tile_size - sprite_size.y)
