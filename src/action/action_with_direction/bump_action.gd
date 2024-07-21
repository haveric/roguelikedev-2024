class_name BumpAction extends _ActionWithDirection

func perform(map: Map) -> _Action:
	if !entity.components.has("position"):
		return UnableToPerformAction.new(entity, "Entity doesn't have a position.")

	if dx == 0 && dy == 0: # Wait
		return MovementAction.new(entity, dx, dy).perform(map)

	var position: Position = entity.components.get("position")

	var dest_x: int = position.x + dx
	var dest_y: int = position.y + dy

	if !map.is_in_bounds(dest_x, dest_y):
		return UnableToPerformAction.new(entity, "Location is outside the map!")

	var blocking_entity = map.get_blocking_entity_at_location(dest_x, dest_y)
	if blocking_entity:
		return MeleeAction.new(entity, dx, dy, blocking_entity).perform(map)

	var furniture_tile: MapTile = map.furniture_tiles[dest_x][dest_y]
	var ground_tile: MapTile = map.ground_tiles[dest_x][dest_y]
	if furniture_tile.entity || ground_tile.entity:
		return MovementAction.new(entity, dx, dy).perform(map)

	return UnableToPerformAction.new(entity, "Nowhere to move")
