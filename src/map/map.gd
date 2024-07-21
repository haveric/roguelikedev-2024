class_name Map extends Node2D

@onready var ground_tiles_node: Node = $GroundTiles
@onready var furniture_tiles_node: Node = $FurnitureTiles
@onready var entity_tiles_node: Node = $EntityTiles
@onready var item_tiles_node: Node = $ItemTiles
@onready var shroud_tiles_node: Node = $ShroudTiles
var packed_map_tile: PackedScene = preload("res://src/map/map_tile.tscn")

var id: String
var width: int
var height: int

var ground_tiles: Array
var furniture_tiles: Array
var actors: Array
var items: Array
var shroud_tiles: Array
var player: _Entity
var camera: Camera2D

func init_map(_width:int, _height:int, _player: _Entity, _camera: Camera2D) -> void:
	width = _width
	height = _height
	ground_tiles = init_tile_array()
	furniture_tiles = init_tile_array()
	actors = []
	items = []
	shroud_tiles = init_tile_array()
	init_shroud()
	player = _player
	camera = _camera
	BSPGenerator.generate(self)
	update_connected_tiles(ground_tiles)
	update_connected_tiles(furniture_tiles)

	actors.append(player)

func init_tile_array() -> Array:
	var tiles = []
	for i in range(width):
		tiles.append([])

		for j in range(height):
			var map_tile = packed_map_tile.instantiate()

			tiles[i].append(map_tile)

	return tiles

func init_shroud() -> void:
	for i in range(width):
		for j in range(height):
			shroud_tiles[i][j].entity = EntityLoader.create("shroud", {"position": {"x": i, "y": j}, "fov": {}})

func update_connected_tiles(tiles: Array) -> void:
	for i in range(width):
		for j in range(height):
			var map_tile: MapTile = tiles[i][j]
			if map_tile.entity && map_tile.entity.components.has("connected_texture"):
				var connected_texture = map_tile.entity.components.get("connected_texture")
				var texture = connected_texture.get_sprite(self, tiles, i, j)
				map_tile.entity.sprite = texture

			if map_tile.entity && map_tile.entity.components.has("tilable"):
				var tilable = map_tile.entity.components.get("tilable")
				var texture = tilable.get_sprite(self, i, j)
				map_tile.entity.sprite = texture

func clear() -> void:
	for child in ground_tiles_node.get_children():
		child.queue_free()

	for child in furniture_tiles_node.get_children():
		child.queue_free()

	for child in entity_tiles_node.get_children():
		if child.entity != player:
			child.queue_free()

	for child in item_tiles_node.get_children():
		child.queue_free()

	for child in shroud_tiles_node.get_children():
		child.queue_free()

func generate() -> void:
	place_tiles()
	place_actors()
	place_items()

func place_tiles() -> void:
	for i in range(width):
		for j in range(height):
			ground_tiles_node.add_child(ground_tiles[i][j])
			furniture_tiles_node.add_child(furniture_tiles[i][j])
			shroud_tiles_node.add_child(shroud_tiles[i][j])

func place_actors() -> void:
	for entity: _Entity in actors:
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
	for entity in actors:
		if entity.components.has("position"):
			var entity_position = entity.components.get("position")
			if entity_position.x == x && entity_position.y == y && entity.components.has("blocks_movement"):
				var blocks_movement_component = entity.components.get("blocks_movement")
				if blocks_movement_component.blocks_movement:
					return entity

	return null
