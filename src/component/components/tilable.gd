class_name Tilable extends _ExportableComponent

@export var tilable_texture: AtlasTexture

var tile_size = 128

var x_offset: int
var y_offset: int

func _init(json: Dictionary = {}) -> void:
	super("tilable", json)

func parse_json(json: Dictionary = {}) -> void:
	if json.has("tilable"):
		x_offset = json.get("tilable").x_offset
		y_offset = json.get("tilable").y_offset

func get_sprite(map: Map, x: int, y: int) -> Texture2D:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = tilable_texture.atlas
	var size: Vector2i = atlas_texture.get_size() / tile_size
	atlas_texture.region = get_rect(x % size.x, y % size.y)

	return atlas_texture

func get_rect(x: int, y: int) -> Rect2:
	return Rect2(x * tile_size, y * tile_size, tile_size, tile_size)
