class_name UnableToPerformAction extends _Action

var reason: String

func _init(_entity: _Entity, _reason: String) -> void:
	super(_entity)
	reason = _reason

func perform(map: Map) -> _Action:
	return self
