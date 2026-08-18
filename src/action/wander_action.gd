class_name WanderAction extends _Action

func perform(map: Map) -> _Action:
	var dx: int = randi_range(-1, 1)
	var dy: int = randi_range(-1, 1)

	return MovementAction.new(entity, dx, dy).perform(map)
