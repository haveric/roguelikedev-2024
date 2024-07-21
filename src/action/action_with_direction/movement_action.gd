class_name MovementAction extends _ActionWithDirection

func perform(map: Map) -> _Action:
	if !entity.components.has("position"):
		return UnableToPerformAction.new(entity, "Entity doesn't have a position.")

	if dx == 0 && dy == 0: # Wait
		return self

	var position: Position = entity.components.get("position")

	var dest_x: int = position.x + dx
	var dest_y: int = position.y + dy

	if !map.is_in_bounds(dest_x, dest_y):
		return UnableToPerformAction.new(entity, "Location is outside the map!")

	var blocking_entity = map.get_blocking_entity_at_location(dest_x, dest_y)
	if blocking_entity:
		return UnableToPerformAction.new(entity, "There's an Entity " + blocking_entity.name + " in the way!")

	var furniture_tile: MapTile = map.furniture_tiles[dest_x][dest_y]
	if furniture_tile:
		var tile_entity = furniture_tile.entity
		if tile_entity && tile_entity.components.has("blocks_movement"):
			var blocks_movement_component = tile_entity.components.get("blocks_movement")
			if blocks_movement_component.blocks_movement:
				return UnableToPerformAction.new(entity, "There's a furniture " + tile_entity.name + " in the way!")

	var ground_tile: MapTile = map.ground_tiles[dest_x][dest_y]
	if ground_tile:
		var tile_entity = ground_tile.entity
		if tile_entity && tile_entity.components.has("blocks_movement"):
			var blocks_movement_component = tile_entity.components.get("blocks_movement")
			if blocks_movement_component.blocks_movement:
				return UnableToPerformAction.new(entity, "There's a ground " + tile_entity.name + " in the way!")

	position.move(dx, dy)

	return self
