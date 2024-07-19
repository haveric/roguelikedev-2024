class_name Map extends Node2D

@onready var map_tiles_node: Node = $MapTiles
@onready var entity_tiles_node: Node = $EntityTiles
@onready var item_tiles_node: Node = $ItemTiles
var packed_map_tile: PackedScene = preload("res://src/map/map_tile.tscn")

var id: String
var width: int
var height: int

var tiles: Array
var entities: Array
var items: Array
var player: _Entity
var camera: Camera2D

func init_map(_width:int, _height:int, _player: _Entity, _camera: Camera2D) -> void:
	width = _width
	height = _height
	init_tile_array()
	entities = []
	items = []
	player = _player
	camera = _camera
	BSPGenerator.generate(self)
	update_connected_tiles()

	entities.append(player)

func init_tile_array() -> void:
	tiles = []
	for i in range(width):
		tiles.append([])

		for j in range(height):
			var map_tile = packed_map_tile.instantiate()

			tiles[i].append(map_tile)

func update_connected_tiles() -> void:
	for i in range(width):
		for j in range(height):
			var map_tile: MapTile = tiles[i][j]
			if map_tile.entity.components.has("connected_texture"):
				var connected_texture = map_tile.entity.components.get("connected_texture")
				var texture = connected_texture.get_sprite(self, i, j)
				map_tile.entity.sprite = texture

func clear() -> void:
	for child in map_tiles_node.get_children():
		child.queue_free()

	for child in entity_tiles_node.get_children():
		if child.entity != player:
			child.queue_free()

	for child in item_tiles_node.get_children():
		child.queue_free()

func generate() -> void:
	place_tiles()
	place_entities()
	place_items()

func place_tiles() -> void:
	for i in range(width):
		for j in range(height):
			map_tiles_node.add_child(tiles[i][j])

func place_entities() -> void:
	for entity: _Entity in entities:
		var map_tile = packed_map_tile.instantiate()
		map_tile.set_entity(entity)

		entity_tiles_node.add_child(map_tile)
		if entity == player:
			map_tile.add_child(camera)

func place_items() -> void:
	for item in items:
		var map_tile = packed_map_tile.instantiate()
		map_tile.set_entity(item)
		item_tiles_node.add_child(map_tile)

func is_in_bounds(x: int, y: int) -> bool:
	return 0 <= x && x < width && 0 <= y && y < height

func get_blocking_entity_at_location(x: int, y: int) -> _Entity:
	for entity in entities:
		if entity.components.has("position"):
			var entity_position = entity.components.get("position")
			if entity_position.x == x && entity_position.y == y && entity.components.has("blocks_movement"):
				var blocks_movement_component = entity.components.get("blocks_movement")
				if blocks_movement_component.blocks_movement:
					return entity

	return null
