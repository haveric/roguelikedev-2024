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
			
			var furniture_tile:MapTile = map.furniture_tiles[i][j]
			if furniture_tile.entity:
				if furniture_tile.entity.id == "road":
					var set_crosswalk = false
					if !set_crosswalk && map.is_in_bounds(i - 1, j - 1) && map.is_in_bounds(i + 1, j - 1):
						var entity_nw = map.furniture_tiles[i - 1][j - 1].entity
						var entity_n = map.furniture_tiles[i][j - 1].entity
						var entity_ne = map.furniture_tiles[i + 1][j - 1].entity
						
						if entity_nw && entity_nw.id == "road" && entity_n && entity_n.id == "road" && entity_ne && entity_ne.id == "road":
							var rand = randi_range(0, 100)
							if rand < 20:
								furniture_tile.set_entity(EntityLoader.create("road_crosswalk_ns", {"position": {"x": i, "y": j}}))
								set_crosswalk = true
								
					if !set_crosswalk && map.is_in_bounds(i - 1, j + 1) && map.is_in_bounds(i + 1, j + 1):
						var entity_sw = map.furniture_tiles[i - 1][j + 1].entity
						var entity_s = map.furniture_tiles[i][j + 1].entity
						var entity_se = map.furniture_tiles[i + 1][j + 1].entity
						
						if entity_sw && entity_sw.id == "road" && entity_s && entity_s.id == "road" && entity_se && entity_se.id == "road":
							var rand = randi_range(0, 100)
							if rand < 20:
								furniture_tile.set_entity(EntityLoader.create("road_crosswalk_ns", {"position": {"x": i, "y": j}}))
								set_crosswalk = true
								
					if !set_crosswalk && map.is_in_bounds(i - 1, j - 1) && map.is_in_bounds(i - 1, j + 1):
						var entity_nw = map.furniture_tiles[i - 1][j - 1].entity
						var entity_w = map.furniture_tiles[i - 1][j].entity
						var entity_sw = map.furniture_tiles[i - 1][j + 1].entity
						
						if entity_nw && entity_nw.id == "road" && entity_w && entity_w.id == "road" && entity_sw && entity_sw.id == "road":
							var rand = randi_range(0, 100)
							if rand < 20:
								furniture_tile.set_entity(EntityLoader.create("road_crosswalk_ew", {"position": {"x": i, "y": j}}))
								set_crosswalk = true
					
					if !set_crosswalk && map.is_in_bounds(i + 1, j - 1) && map.is_in_bounds(i + 1, j + 1):
						var entity_ne = map.furniture_tiles[i + 1][j - 1].entity
						var entity_e = map.furniture_tiles[i + 1][j].entity
						var entity_se = map.furniture_tiles[i + 1][j + 1].entity
						
						if entity_ne && entity_ne.id == "road" && entity_e && entity_e.id == "road" && entity_se && entity_se.id == "road":
							var rand = randi_range(0, 100)
							if rand < 20:
								furniture_tile.set_entity(EntityLoader.create("road_crosswalk_ew", {"position": {"x": i, "y": j}}))
								set_crosswalk = true
						
			
			var map_tile:MapTile = map.ground_tiles[i][j]
			if !map_tile.entity:
				map_tile.set_entity(EntityLoader.create("grass_empty", {"position": {"x": i, "y": j}}))

	var potential_buildings = []
	var potential_buildings_map = init_2d_array(map.width, map.height, 1)
	for i in range(grass_rect.position.x, grass_rect.end.x):
		for j in range(grass_rect.position.y, grass_rect.end.y):
			potential_buildings_map[i][j] = 0

	for i in range(grass_rect.position.x, grass_rect.end.x):
		for j in range(grass_rect.position.y, grass_rect.end.y):
			walk_tiles(potential_buildings, potential_buildings_map, i, j)
	
	add_buildings(potential_buildings)

	var entity
	for i in range(grass_rect.position.x, grass_rect.end.x):
		for j in range(grass_rect.position.y, grass_rect.end.y):
			entity = null
			
			var furniture_tile:MapTile = map.furniture_tiles[i][j]
			if furniture_tile.entity:
				continue
				
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
				if randj < 47:
					entity = EntityLoader.create("house_1", {"position": {"x": i, "y": j}})
				elif randj < 94:
					entity = EntityLoader.create("house_2", {"position": {"x": i, "y": j}})
				else:
					entity = EntityLoader.create("shop", {"position": {"x": i, "y": j}})

			if entity != null:
				furniture_tile.set_entity(entity)

	for i in 10:
		var rand = randi_range(0, open_tiles.size() - 1)
		var tile: Vector2i = open_tiles.pop_at(rand)
		var actor
		var rand_actor = randi_range(0, 100)
		if rand_actor < 50:
			actor = "construction_worker"
		elif rand_actor < 80:
			actor = "police_officer"
		else:
			actor = "police_car"

		map.actors.append(EntityLoader.create(actor, {"position": {"x": tile.x, "y": tile.y}}))

static func add_buildings(potential_buildings):
	var num_5x3 = 2
	var num_3x5 = 2
	var num_3x3 = 3
	var num_3x2 = 4
	var num_2x2 = 10

	add_large_building(potential_buildings, num_5x3, 5, 3, "building_5x3")
	add_large_building(potential_buildings, num_3x5, 3, 5, "building_3x5")
	add_large_building(potential_buildings, num_3x3, 3, 3, "building_3x3")
	add_large_building(potential_buildings, num_3x2, 3, 2, "building_3x2")
	add_large_building(potential_buildings, num_2x2, 2, 2, "building_2x2")

	
static func add_large_building(potential_buildings, num, w, h, entity):
	for i in num:
		potential_buildings.shuffle()
		var index = 0
		for building in potential_buildings:
			if (building.width >= w && building.height >= h):
				var x = randi_range(building.x, building.x + building.width - w)
				var y = randi_range(building.y, building.y + building.height - h)
				var building_entity = EntityLoader.create(entity, {"position": {"x": x, "y": y}})
				map.furniture_tiles[x][y].set_entity(building_entity)
				for entity_x in range(x, x + w):
					for entity_y in range(y, y + h):
						if entity_x == x && entity_y == y:
							continue
						
						var fake_entity = EntityLoader.create(entity, {"position": {"x": entity_x, "y": entity_y}})
						fake_entity.sprite = null
						map.furniture_tiles[entity_x][entity_y].set_entity(fake_entity)
				
				potential_buildings.remove_at(index)
				if (x > building.x):
					var new_building_left = {
						"x": building.x,
						"y": building.y,
						"width": x - building.x,
						"height": building.height
					}
					potential_buildings.append(new_building_left)
				if (x + w < building.x + building.width):
					var new_building_right = {
						"x": x + w,
						"y": building.y,
						"width": building.x + building.width - w - x,
						"height": building.height
					}
					potential_buildings.append(new_building_right)
					
				if (y > building.y):
					var new_building_top = {
						"x": x,
						"y": building.y,
						"width": w,
						"height": y - building.y
					}
					potential_buildings.append(new_building_top)
					
				if (y + h < building.y + building.height):
					var new_building_bottom = {
						"x": x,
						"y": y + h,
						"width": w,
						"height": building.y + building.height - h - y
					}
					potential_buildings.append(new_building_bottom)
				break
			index += 1

static func walk_tiles(potential_buildings, potential_buildings_map, i, j):
	if (potential_buildings_map[i][j] == 0):
		if map.furniture_tiles[i][j].entity:
			potential_buildings_map[i][j] = 1;
			return
		else:
			var new_building = {
				"x": i,
				"y": j,
				"width": 1,
				"height": 1
			}
			
			var temp_i = i;
			var temp_j = j
			
			while(true):
				temp_i += 1
				if temp_i >= potential_buildings_map.size() - 1:
					break
				
				if (potential_buildings_map[temp_i][temp_j] == 0):
					if map.furniture_tiles[temp_i][temp_j].entity:
						break
					else:
						new_building.width += 1
				
			temp_i = i
			while(true):
				temp_j += 1
				
				if temp_j >= potential_buildings_map[temp_i].size() - 1:
					break

				if (potential_buildings_map[temp_i][temp_j] == 0):
					if map.furniture_tiles[temp_i][temp_j].entity:
						break
					else:
						new_building.height += 1
				
			for x in range(i, i + new_building.width):
				for y in range(j, j + new_building.height):
					potential_buildings_map[x][y] = 1;
			potential_buildings.append(new_building)

static func init_2d_array(width, height, value) -> Array:
	var array = []
	array.resize(width)
	
	for i in range(width):
		array[i] = []
		array[i].resize(height)
		
		if (value != null):
			for j in range(height):
				array[i][j] = value	

	return array
	
static func create_beach() -> Rect2i:
	var beach_size = 6
	var water_size = 5
	var shore_size = beach_size + water_size
	var rect_beach: Rect2i
	var rect_beach_no_edge: Rect2i
	var rect_water: Rect2i
	var rect_grass: Rect2i

	var rand_beach_dir = randi_range(0, 3)
	if rand_beach_dir == 0: # Left
		rect_water = Rect2i(0, 0, water_size, map.height)
		rect_beach = Rect2i(water_size, 0, beach_size, map.height)
		rect_beach_no_edge = Rect2i(water_size + 1, 0, beach_size - 1, map.height)
		rect_grass = Rect2i(shore_size, 0, map.width - shore_size, map.height)
	elif rand_beach_dir == 1: # Right
		rect_water = Rect2i(map.width - water_size, 0, water_size, map.height)
		rect_beach = Rect2i(map.width - shore_size, 0, beach_size, map.height)
		rect_beach_no_edge = Rect2i(map.width - shore_size, 0, beach_size - 1, map.height)
		rect_grass = Rect2i(0, 0, map.width - shore_size, map.height)
	elif rand_beach_dir == 2: # Top
		rect_water = Rect2i(0, 0, map.width, water_size)
		rect_beach = Rect2i(0, water_size, map.width, beach_size)
		rect_beach_no_edge = Rect2i(0, water_size + 1, map.width, beach_size - 1)
		rect_grass = Rect2i(0, shore_size, map.width, map.height - shore_size)
	else: # Bottom
		rect_water = Rect2i(0, map.height - water_size, map.width, water_size)
		rect_beach = Rect2i(0, map.height - shore_size, map.width, beach_size)
		rect_beach_no_edge = Rect2i(0, map.height - shore_size, map.width, beach_size - 1)
		rect_grass = Rect2i(0, 0, map.width, map.height - shore_size)

	var player_position = map.player.components.position
	player_position.x = randi_range(rect_water.position.x, rect_water.position.x + rect_water.size.x - 1)
	player_position.y = randi_range(rect_water.position.y, rect_water.position.y + rect_water.size.y - 1)
	
	for i in range(rect_beach.position.x, rect_beach.position.x + rect_beach.size.x):
		for j in range(rect_beach.position.y, rect_beach.position.y + rect_beach.size.y):
			var map_tile:MapTile = map.ground_tiles[i][j]
			
			var beach_tile_string = "beach_empty"
			if rand_beach_dir == 0: # Left
				if i == rect_beach.position.x:
					beach_tile_string = "beach_w"
			elif rand_beach_dir == 1: # Right
				if i == rect_beach.position.x + rect_beach.size.x - 1:
					beach_tile_string = "beach_e"
			elif rand_beach_dir == 2: # Top
				if j == rect_beach.position.y:
					beach_tile_string = "beach_n"
			else: # Bottom
				if j == rect_beach.position.y + rect_beach.size.y - 1:
					beach_tile_string = "beach_s"
				
			map_tile.set_entity(EntityLoader.create(beach_tile_string, {"position": {"x": i, "y": j}}))

	var num_beach_items = 10
	for i in num_beach_items:
		var rand_item = randi_range(0, 100)
		var beach_item_string
		if rand_item < 50:
			beach_item_string = "beach_ball"
		else:
			beach_item_string = "umbrella"
			
		var x = randi_range(rect_beach_no_edge.position.x, rect_beach_no_edge.position.x + rect_beach_no_edge.size.x - 1)
		var y = randi_range(rect_beach_no_edge.position.y, rect_beach_no_edge.position.y + rect_beach_no_edge.size.y - 1)
		map.furniture_tiles[x][y].set_entity(EntityLoader.create(beach_item_string, {"position": {"x": x, "y": y}}))

		
	
	var water_tile_strings
	if rand_beach_dir == 0 || rand_beach_dir == 1:
		water_tile_strings = ["water_empty", "water_v_1", "water_v_2"]
	else:
		water_tile_strings = ["water_empty", "water_h_1", "water_h_2"]
				
	for i in range(rect_water.position.x, rect_water.position.x + rect_water.size.x):
		for j in range(rect_water.position.y, rect_water.position.y + rect_water.size.y):
			var map_tile:MapTile = map.ground_tiles[i][j]

			var water_tile = water_tile_strings.pick_random()
			map_tile.set_entity(EntityLoader.create(water_tile, {"position": {"x": i, "y": j}}))

	var num_dock = 1
	var rand_dock = randi_range(1, 100)
	if rand_dock < 20:
		num_dock = 2

	for i in num_dock:
		if rand_beach_dir == 0: # Left
			var x = rect_beach.position.x
			var y = randi_range(rect_beach.position.y, rect_beach.position.y + rect_beach.size.y - 1)
			map.ground_tiles[x][y].set_entity(EntityLoader.create("dock_w_1", {"position": {"x": x, "y": y}}))
			map.ground_tiles[x-1][y].set_entity(EntityLoader.create("dock_w_2", {"position": {"x": x-1, "y": y}}))
		elif rand_beach_dir == 1: # Right
			var x = rect_beach.position.x + rect_beach.size.x - 1
			var y = randi_range(rect_beach.position.y, rect_beach.position.y + rect_beach.size.y - 1)
			map.ground_tiles[x][y].set_entity(EntityLoader.create("dock_e_1", {"position": {"x": x, "y": y}}))
			map.ground_tiles[x+1][y].set_entity(EntityLoader.create("dock_e_2", {"position": {"x": x+1, "y": y}}))
		elif rand_beach_dir == 2: # Top
			var x = randi_range(rect_beach.position.x, rect_beach.position.x + rect_beach.size.x - 1)
			var y = rect_beach.position.y
			map.ground_tiles[x][y].set_entity(EntityLoader.create("dock_n_1", {"position": {"x": x, "y": y}}))
			map.ground_tiles[x][y-1].set_entity(EntityLoader.create("dock_n_2", {"position": {"x": x, "y": y-1}}))
		else: # Bottom
			var x = randi_range(rect_beach.position.x, rect_beach.position.x + rect_beach.size.x - 1)
			var y = rect_beach.position.y + rect_beach.size.y - 1
			map.ground_tiles[x][y].set_entity(EntityLoader.create("dock_s_1", {"position": {"x": x, "y": y}}))
			map.ground_tiles[x][y+1].set_entity(EntityLoader.create("dock_s_2", {"position": {"x": x, "y": y+1}}))
		

	return rect_grass

static func bsp_split_horizontal(rect: Rect2i) -> void:
	if rect.size.x < 3:
		return

	var i = randi_range(rect.position.x + 1, rect.end.x - 1)
	for j in range(rect.position.y, rect.end.y + 1):
		if map.is_in_bounds(i, j):
			var map_tile:MapTile = map.furniture_tiles[i][j]
			if !map_tile.entity:
				map_tile.set_entity(EntityLoader.create("road", {"position": {"x": i, "y": j}}))
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
				map_tile.set_entity(EntityLoader.create("road", {"position": {"x": i, "y": j}}))
				open_tiles.append(Vector2i(i, j))

	var split_size_1 = Vector2i(rect.end.x, j - 1) - rect.position
	var split_rect_1 = Rect2i(rect.position, split_size_1)

	var split_size_2 = rect.end - Vector2i(rect.position.x, j + 1)
	var split_rect_2 = Rect2i(Vector2i(rect.position.x, j + 1), split_size_2)

	bsp_split_horizontal(split_rect_1)
	bsp_split_horizontal(split_rect_2)
