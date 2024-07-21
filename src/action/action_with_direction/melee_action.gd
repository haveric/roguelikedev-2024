class_name MeleeAction extends _ActionWithDirection

var blocking_entity: _Entity

func _init(_entity: _Entity, _dx: int, _dy: int, _blocking_entity: _Entity) -> void:
	super(_entity, _dx, _dy)

	blocking_entity = _blocking_entity

func perform(map: Map) -> _Action:
	print("You kick " + blocking_entity.name + ", much to its annoyance!")

	return self
