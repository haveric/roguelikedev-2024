## Credit to Adam Milazzo for this fov algorithm: http://www.adammil.net/blog/v125_roguelike_vision_algorithms.html
##
class_name AdamMilazzoFov extends _BaseFov

func compute(map: Map, x: int, y: int, radius: int) -> void:
	super(map, x, y, radius)

	explore_tile(map, x, y)
	for octant in range(0, 8):
		compute_octant(map, octant, x, y, radius, 1, FovSlope.new(1, 1), FovSlope.new(1, 0))

func compute_octant(map: Map, octant: int, origin_x: int, origin_y: int, range_limit: int, _x: int, top: FovSlope, bottom: FovSlope) -> void:
	for x in range(_x, range_limit + 1):
		var top_y: int
		if top.x == 1:
			top_y = x
		else:
			top_y = round(((x * 2 - 1) * top.y + top.x) / (top.x * 2))

			if blocks_light(map, octant, origin_x, origin_y, x, top_y):
				if top.greater_or_equal(x * 2, top_y * 2 + 1) && !blocks_light(map, octant, origin_x, origin_y, x, top_y + 1):
					top_y += 1
			else:
				var ax = x * 2
				if blocks_light(map, octant, origin_x, origin_y, x + 1, top_y + 1):
					ax += 1

				if top.greater(ax, top_y * 2 + 1):
					top_y += 1

		var bottom_y: int
		if bottom.y == 0:
			bottom_y = 0
		else:
			bottom_y = ((x * 2 - 1) * bottom.y + bottom.x) / (bottom.x * 2)

			if bottom.greater_or_equal(x * 2, bottom_y * 2 + 1) && blocks_light(map, octant, origin_x, origin_y, x, bottom_y) && !blocks_light(map, octant, origin_x, origin_y, x, bottom_y + 1):
				bottom_y += 1

		var was_opaque = -1 # 0:false, 1:true, -1:not applicable
		for y in range(top_y, bottom_y - 1, -1):
			var is_opaque = blocks_light(map, octant, origin_x, origin_y, x, y)
			var is_visible = is_opaque || ((y != top_y || top.greater_or_equal(x, y)) && (y != bottom_y || bottom.less_or_equal(x, y)))

			if is_visible:
				set_visible(map, octant, origin_x, origin_y, x, y)

			if x != range_limit:
				if is_opaque:
					if was_opaque == 0:
						var nx = x * 2
						var ny = y * 2 + 1

						if top.greater(nx, ny):
							if y == bottom_y:
								bottom = FovSlope.new(nx, ny)
								break
							else:
								compute_octant(map, octant, origin_x, origin_y, range_limit, x + 1, top, FovSlope.new(nx, ny))
						else:
							if y == bottom_y:
								return

					was_opaque = 1
				else:
					if was_opaque > 0:
						var nx = x * 2
						var ny = y * 2 + 1

						if bottom.greater_or_equal(nx, ny):
							return

						top = FovSlope.new(nx, ny)

					was_opaque = 0

		if was_opaque != 0:
			break

func blocks_light(map, octant, origin_x, origin_y, x, y) -> bool:
	match octant:
		0:
			origin_x += x;
			origin_y -= y;
		1:
			origin_x += y;
			origin_y -= x;
		2:
			origin_x -= y;
			origin_y -= x;
		3:
			origin_x -= x;
			origin_y -= y;
		4:
			origin_x -= x;
			origin_y += y;
		5:
			origin_x -= y;
			origin_y += x;
		6:
			origin_x += y;
			origin_y += x;
		7:
			origin_x += x;
			origin_y += y;

	var blocks_light: bool = false

	if map.is_in_bounds(origin_x, origin_y):
		var furniture_tile: MapTile = map.furniture_tiles[origin_x][origin_y]
		if furniture_tile:
			var tile_entity = furniture_tile.entity
			if tile_entity && tile_entity.components.has("blocks_fov"):
				var blocks_fov = tile_entity.components.get("blocks_fov")
				if blocks_fov.blocks_fov:
					blocks_light = true

		if !blocks_light:
			var ground_tile: MapTile = map.ground_tiles[origin_x][origin_y]
			if ground_tile:
				var tile_entity = ground_tile.entity
				if tile_entity && tile_entity.components.has("blocks_fov"):
					var blocks_fov = tile_entity.components.get("blocks_fov")
					if blocks_fov.blocks_fov:
						blocks_light = true

	return blocks_light;

func set_visible(map, octant, origin_x, origin_y, x, y) -> void:
	match octant:
		0:
			origin_x += x;
			origin_y -= y;
		1:
			origin_x += y;
			origin_y -= x;
		2:
			origin_x -= y;
			origin_y -= x;
		3:
			origin_x -= x;
			origin_y -= y;
		4:
			origin_x -= x;
			origin_y += y;
		5:
			origin_x -= y;
			origin_y += x;
		6:
			origin_x += y;
			origin_y += x;
		7:
			origin_x += x;
			origin_y += y;

	explore_tile(map, origin_x, origin_y)
