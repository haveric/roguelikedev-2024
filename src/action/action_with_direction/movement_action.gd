class_name MovementAction extends _ActionWithDirection

func perform() -> _Action:
	if entity.components.has("position"):
		var position: Position = entity.components.get("position")
		position.move(dx, dy)

		return self

	return null
