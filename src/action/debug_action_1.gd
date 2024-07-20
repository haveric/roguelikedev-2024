class_name DebugAction1 extends _Action

func perform(map: Map) -> _Action:
	map.clear()
	map.init_map(map.width, map.height, map.player, map.camera)
	map.generate()

	return NoAction.new(entity)
