class_name _BaseFov extends Node

var visible_actors: Array
var visible_items: Array
var previously_visible_shroud: Array
var previously_visible_actors: Array
var visible_shroud: Array
var left: int
var right: int
var top: int
var bottom: int
var rect: Rect2i

func __init() -> void:
	teardown()

func teardown() -> void:
	previously_visible_shroud = []
	previously_visible_actors = []
	left = 0
	right = 0
	top = 0
	bottom = 0
	clear_visible()

func clear_visible() -> void:
	visible_actors = []
	visible_items = []
	visible_shroud = []

func compute(map: Map, x: int, y: int, radius: int) -> void:
	previously_visible_shroud = visible_shroud
	previously_visible_actors = visible_actors
	clear_visible()

	left = max(0, x - radius)
	right = min(map.width, x + radius + 1)
	top = max(0, y - radius)
	bottom = min(map.height, y + radius + 1)
	var start = Vector2i(left, top)
	var end = Vector2i(right, bottom)
	rect = Rect2i(start, end - start)

func add_visible_actors(tile) -> void:
	if !visible_actors.has(tile):
		visible_actors.append(tile)

func add_visible_items(tile) -> void:
	if !visible_items.has(tile):
		visible_items.append(tile)

func add_visible_shroud(tile) -> void:
	if !visible_shroud.has(tile):
		visible_shroud.append(tile)

func reveal_map(map) -> void:
	for i in range(0, map.width):
		for j in range(0, map.height):
			explore_tile(map, i, j)
		
func explore_tile(map, x, y) -> void:
	if map.is_in_bounds(x, y):
		add_visible_shroud(map.shroud_tiles[x][y])

		for actor in map.actors:
			var position = actor.components.position
			if position && position.is_at(x, y):
				visible_actors.append(actor)

		for item in map.items:
			var position = item.components.position
			if position && position.is_at(x, y):
				visible_items.append(item)

func update_map() -> void:
	for shroud in previously_visible_shroud:
		shroud.entity.components.fov.visible = false
		shroud.modulate.a = 0.75
		shroud.set_visible(true)

	for shroud in visible_shroud:
		var shroud_fov = shroud.entity.components.fov
		shroud.modulate.a = 1
		shroud.set_visible(false)
		shroud_fov.visible = true
		shroud_fov.explored = true

	for actor in previously_visible_actors:
		actor.map_tile.set_visible(false)

	for actor in visible_actors:
		actor.map_tile.set_visible(true)
