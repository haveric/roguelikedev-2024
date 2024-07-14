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

func init_map(_width:int, _height:int, player: _Entity) -> void:
	width = _width
	height = _height
	init_tile_array()
	entities = []
	items = []

	entities.append(player)

func init_tile_array() -> void:
	tiles = []
	for i in range(width):
		tiles.append([])

		for j in range(height):
			var map_tile = packed_map_tile.instantiate()

			tiles[i].append(map_tile)

			var entity = EntityLoader.create("road", {"position": {"x": i, "y": j}})
			if entity != null:
				map_tile.set_entity(entity)

func generate() -> void:
	place_tiles()
	place_entities()
	place_items()

func place_tiles() -> void:
	for i in range(width):
		for j in range(height):
			map_tiles_node.add_child(tiles[i][j])

func place_entities() -> void:
	for entity in entities:
		var map_tile = packed_map_tile.instantiate()
		map_tile.set_entity(entity)

		entity_tiles_node.add_child(map_tile)

func place_items() -> void:
	for item in items:
		var map_tile = packed_map_tile.instantiate()
		map_tile.set_entity(item)
		item_tiles_node.add_child(map_tile)
