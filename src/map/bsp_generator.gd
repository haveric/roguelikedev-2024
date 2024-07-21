class_name BSPGenerator extends Node

static var map: Map
static var open_tiles: Array[Vector2i]

static func generate(_map: Map) -> void:
	map = _map
	open_tiles = []

	var grass_rect: Rect2i = create_beach()

	var rand_road_dir = randi_range(0, 1)
	if rand_road_dir == 0:
		bsp_split_horizontal(Rect2i(grass_rect.position, Vector2i(grass_rect.end.x - 1, grass_rect.end.y - 1)))
	else:
		bsp_split_vertical(Rect2i(grass_rect.position, Vector2i(grass_rect.end.x - 1, grass_rect.end.y - 1)))

	for i in range(grass_rect.position.x, grass_rect.end.x):
		for j in range(grass_rect.position.y, grass_rect.end.y):
			var map_tile:MapTile = map.ground_tiles[i][j]
			if !map_tile.entity:
				map_tile.entity = EntityLoader.create("grass_empty", {"position": {"x": i, "y": j}})

	var entity
	for i in range(grass_rect.position.x, grass_rect.end.x):
		for j in range(grass_rect.position.y, grass_rect.end.y):
			entity = null

			var furniture_tile:MapTile = map.furniture_tiles[i][j]
			if !furniture_tile.entity:
				var randi = randi_range(0, 100)
				if randi < 20:
					open_tiles.append(Vector2i(i, j))
					var rand_grass = randi_range(0, 100)
					var grass_type = ""
					if rand_grass < 15:
						grass_type = "grass_1"
					elif rand_grass < 30:
						grass_type = "grass_2"
					elif rand_grass < 45:
						grass_type = "flowers_1"
					elif rand_grass < 60:
						grass_type = "flowers_2"
					else:
						grass_type = ""

					if grass_type != "":
						entity = EntityLoader.create(grass_type, {"position": {"x": i, "y": j}})
				else:
					var randj = randi_range(0, 100)
					if randj < 40:
						entity = EntityLoader.create("building_1", {"position": {"x": i, "y": j}})
					else:
						entity = EntityLoader.create("building_2", {"position": {"x": i, "y": j}})

				if entity != null:
					furniture_tile.set_entity(entity)

	for i in 10:
		var rand = randi_range(0, open_tiles.size())
		var tile: Vector2i = open_tiles.pop_at(rand)
		map.entities.append(EntityLoader.create("police_officer", {"position": {"x": tile.x, "y": tile.y}}))

static func create_beach() -> Rect2i:
	var beach_size = 3
	var water_size = 3
	var shore_size = beach_size + water_size
	var rect_beach: Rect2i
	var rect_water: Rect2i
	var rect_grass: Rect2i

	var rand_beach_dir = randi_range(0, 3)
	if rand_beach_dir == 0: # Left
		rect_water = Rect2i(0, 0, beach_size, map.height)
		rect_beach = Rect2i(beach_size, 0, water_size, map.height)
		rect_grass = Rect2i(shore_size, 0, map.width - shore_size, map.height)
	elif rand_beach_dir == 1: # Right
		rect_water = Rect2i(map.width - beach_size, 0, beach_size, map.height)
		rect_beach = Rect2i(map.width - shore_size, 0, water_size, map.height)
		rect_grass = Rect2i(0, 0, map.width - shore_size, map.height)
	elif rand_beach_dir == 2: # Top
		rect_water = Rect2i(0, 0, map.width, beach_size)
		rect_beach = Rect2i(0, beach_size, map.width, water_size)
		rect_grass = Rect2i(0, shore_size, map.width, map.height - shore_size)
	else: # Bottom
		rect_water = Rect2i(0, map.height - beach_size, map.width, beach_size)
		rect_beach = Rect2i(0, map.height - shore_size, map.width, water_size)
		rect_grass = Rect2i(0, 0, map.width, map.height - shore_size)

	var player_position = map.player.components.position
	player_position.x = randi_range(rect_beach.position.x, rect_beach.position.x + rect_beach.size.x - 1)
	player_position.y = randi_range(rect_beach.position.y, rect_beach.position.y + rect_beach.size.y - 1)

	for i in range(rect_beach.position.x, rect_beach.position.x + rect_beach.size.x):
		for j in range(rect_beach.position.y, rect_beach.position.y + rect_beach.size.y):
			var map_tile:MapTile = map.ground_tiles[i][j]
			map_tile.entity = EntityLoader.create("beach", {"position": {"x": i, "y": j}})

	for i in range(rect_water.position.x, rect_water.position.x + rect_water.size.x):
		for j in range(rect_water.position.y, rect_water.position.y + rect_water.size.y):
			var map_tile:MapTile = map.ground_tiles[i][j]
			map_tile.entity = EntityLoader.create("water", {"position": {"x": i, "y": j}})

	return rect_grass

static func bsp_split_horizontal(rect: Rect2i) -> void:
	if rect.size.x < 3:
		return

	var i = randi_range(rect.position.x + 1, rect.end.x - 1)
	for j in range(rect.position.y, rect.end.y + 1):
		if map.is_in_bounds(i, j):
			var map_tile:MapTile = map.furniture_tiles[i][j]
			if !map_tile.entity:
				map_tile.entity = EntityLoader.create("road", {"position": {"x": i, "y": j}})
				open_tiles.append(Vector2i(i, j))

	var split_size_1 = Vector2i(i - 1, rect.end.y) - rect.position
	var split_rect_1 = Rect2i(rect.position, split_size_1)

	var split_size_2 = rect.end - Vector2i(i + 1, rect.position.y)
	var split_rect_2 = Rect2i(Vector2i(i + 1, rect.position.y), split_size_2)

	bsp_split_vertical(split_rect_1)
	bsp_split_vertical(split_rect_2)

static func bsp_split_vertical(rect: Rect2i) -> void:
	if rect.size.y < 3:
		return

	var j = randi_range(rect.position.y + 1, rect.end.y - 1)

	for i in range(rect.position.x, rect.end.x + 1):
		if map.is_in_bounds(i, j):
			var map_tile:MapTile = map.furniture_tiles[i][j]
			if !map_tile.entity:
				map_tile.entity = EntityLoader.create("road", {"position": {"x": i, "y": j}})
				open_tiles.append(Vector2i(i, j))

	var split_size_1 = Vector2i(rect.end.x, j - 1) - rect.position
	var split_rect_1 = Rect2i(rect.position, split_size_1)

	var split_size_2 = rect.end - Vector2i(rect.position.x, j + 1)
	var split_rect_2 = Rect2i(Vector2i(rect.position.x, j + 1), split_size_2)

	bsp_split_horizontal(split_rect_1)
	bsp_split_horizontal(split_rect_2)
