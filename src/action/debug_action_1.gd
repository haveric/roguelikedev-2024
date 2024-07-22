class_name DebugAction1 extends _Action

func perform(map: Map) -> _Action:
	map.clear()
	map.init_map(map.width, map.height, map.player, map.camera)
	map.generate()

	var player_position = map.player.components.position
	var player_fov = map.player.fov
	player_fov.teardown()
	player_fov.compute(map, player_position.x, player_position.y, 5)
	player_fov.update_map()

	return NoAction.new(entity)
