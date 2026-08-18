class_name MeleeAction extends _ActionWithDirection

var blocking_entity: _Entity

func _init(_entity: _Entity, _dx: int, _dy: int, _blocking_entity: _Entity = null) -> void:
	super(_entity, _dx, _dy)

	blocking_entity = _blocking_entity

func perform(map: Map) -> _Action:
	if blocking_entity == null:
		var position: Position = entity.components.get("position")
		if !position:
			return UnableToPerformAction.new(entity, "Entity doesn't have a position.")

		var dest_x = position.x + dx
		var dest_y = position.y + dy

		blocking_entity = map.get_blocking_entity_at_location(dest_x, dest_y)

	if !blocking_entity:
		return UnableToPerformAction.new(entity, "There's nothing to attack there!")

	var entity_fighter: Fighter = entity.components.get("fighter")
	var blocking_fighter: Fighter = blocking_entity.components.get("fighter")
	if entity_fighter && blocking_fighter:
		var name: String
		var plural: String

		if entity == map.player:
			name = "You"
			plural = ""
		else:
			name = entity.name
			plural = "s"

		var blocking_name: String
		var attack_color: Color
		if blocking_entity == map.player:
			blocking_name = "You"
			attack_color = Color(.8, 0, 0)
		else:
			blocking_name = blocking_entity.name
			attack_color = Color(.6, .6, .6)

		var description: String = name + " attack" + plural + " " + blocking_name
		var damage: int = entity_fighter.base_power - blocking_fighter.base_defense
		if damage > 0:
			print(description + " for " + str(damage) + " hit points.")
			blocking_fighter.take_damage(damage)
		else:
			print(description + ", but does no damage.")

		return self
	else:
		return UnableToPerformAction.new(entity, "There's nothing to attack there!")
