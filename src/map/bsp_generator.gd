class_name BSPGenerator extends Node

static var map: Map

static func generate(_map: Map) -> void:
	map = _map

	bsp_split_horizontal(Rect2i(0, 0, map.width, map.height))

	var entity
	for i in range(map.width):
		for j in range(map.height):
			var map_tile:MapTile = map.tiles[i][j]
			if !map_tile.entity:
				var randi = randi_range(0, 100)
				if randi < 20:
					var rand_grass = randi_range(0, 100)
					var grass_type
					if rand_grass < 40:
						grass_type = "grass_empty"
					elif rand_grass < 55:
						grass_type = "grass_1"
					elif rand_grass < 70:
						grass_type = "grass_2"
					elif rand_grass < 85:
						grass_type = "flowers_1"
					else:
						grass_type = "flowers_2"

					entity = EntityLoader.create(grass_type, {"position": {"x": i, "y": j}})
				else:
					entity = EntityLoader.create("grass_empty", {"position": {"x": i, "y": j}})

					var building_entity
					var randj = randi_range(0, 100)
					if randj < 40:
						building_entity = EntityLoader.create("building_1", {"position": {"x": i, "y": j}})
					else:
						building_entity = EntityLoader.create("building_2", {"position": {"x": i, "y": j}})

					map.entities.append(building_entity)

				if entity != null:
					map_tile.set_entity(entity)

static func bsp_split_horizontal(rect: Rect2i) -> void:
	if rect.size.x < 3:
		return

	var i = randi_range(rect.position.x + 1, rect.end.x - 1)
	for j in range(rect.position.y, rect.end.y + 1):
		if map.is_in_bounds(i, j):
			var map_tile:MapTile = map.tiles[i][j]
			map_tile.entity = EntityLoader.create("road", {"position": {"x": i, "y": j}})

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
			var map_tile:MapTile = map.tiles[i][j]
			map_tile.entity = EntityLoader.create("road", {"position": {"x": i, "y": j}})

	var split_size_1 = Vector2i(rect.end.x, j - 1) - rect.position
	var split_rect_1 = Rect2i(rect.position, split_size_1)

	var split_size_2 = rect.end - Vector2i(rect.position.x, j + 1)
	var split_rect_2 = Rect2i(Vector2i(rect.position.x, j + 1), split_size_2)

	bsp_split_horizontal(split_rect_1)
	bsp_split_horizontal(split_rect_2)
