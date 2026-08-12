class_name DebugClearMapAction extends _Action

func perform(map: Map) -> _Action:
	var player_fov = map.player.fov
	player_fov.reveal_map(map)
	player_fov.update_map()

	return NoAction.new(entity)
