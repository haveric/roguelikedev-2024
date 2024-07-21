class_name ConnectedTexture extends _ExportableComponent

@export var orthogonal_texture: AtlasTexture
@export var tile_size = 128

func _init(json: Dictionary = {}) -> void:
	super("connected_texture", json)

func parse_json(json: Dictionary = {}) -> void:
	if json.has("orthogonal_texture"):
		orthogonal_texture = json.orthogonal_texture

func get_sprite(map: Map, tiles: Array, x: int, y: int) -> Texture2D:
	var atlas_texture = AtlasTexture.new()
	if orthogonal_texture:
		atlas_texture.atlas = orthogonal_texture.atlas

		var current_tile = tiles[x][y]
		var entity_id = current_tile.entity.id

		var left_tile
		var right_tile
		var top_tile
		var bottom_tile

		if x - 1 >= 0:
			left_tile = tiles[x-1][y]
		if x + 1 < map.width:
			right_tile = tiles[x+1][y]
		if y - 1 >= 0:
			top_tile = tiles[x][y-1]
		if y + 1 < map.height:
			bottom_tile = tiles[x][y+1]

		var left = left_tile && left_tile.entity && left_tile.entity.id == entity_id
		var right = right_tile && right_tile.entity && right_tile.entity.id == entity_id
		var top = top_tile && top_tile.entity && top_tile.entity.id == entity_id
		var bottom = bottom_tile && bottom_tile.entity && bottom_tile.entity.id == entity_id

		if left && right && top && bottom:
			atlas_texture.region = get_rect(1, 1) # Center
		elif !left && right && top && bottom:
			atlas_texture.region = get_rect(0, 1) # T Right
		elif left && !right && top && bottom:
			atlas_texture.region = get_rect(2, 1) # T Left
		elif left && right && !top && bottom:
			atlas_texture.region = get_rect(1, 0) # T Down
		elif left && right && top && !bottom:
			atlas_texture.region = get_rect(1, 2) # T Up
		elif !left && !right && top && bottom:
			atlas_texture.region = get_rect(3, 1) # Vertical
		elif left && right && !top && !bottom:
			atlas_texture.region = get_rect(1, 3) # Horizontal
		elif !left && right && !top && bottom:
			atlas_texture.region = get_rect(0, 0) # Top Left Corner
		elif left && !right && !top && bottom:
			atlas_texture.region = get_rect(2, 0) # Top Right Corner
		elif !left && right && top && !bottom:
			atlas_texture.region = get_rect(0, 2) # Bottom Left Corner
		elif left && !right && top && !bottom:
			atlas_texture.region = get_rect(2, 2) # Bottom Right Corner
		elif left && !right && !top && !bottom:
			atlas_texture.region = get_rect(2, 3) # End Right
		elif !left && right && !top && !bottom:
			atlas_texture.region = get_rect(0, 3) # End Left
		elif !left && !right && top && !bottom:
			atlas_texture.region = get_rect(3, 2) # End Bottom
		elif !left && !right && !top && bottom:
			atlas_texture.region = get_rect(3, 0) # End Top

		return atlas_texture

	return null

func get_rect(x: int, y: int) -> Rect2:
	return Rect2(x * tile_size, y * tile_size, tile_size, tile_size)
