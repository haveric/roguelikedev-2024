class_name ZoomAction extends _Action

enum ZoomDirection { OUT, IN }

var direction: ZoomDirection

func _init(_entity: _Entity, _direction: ZoomDirection) -> void:
	super(_entity)
	direction = _direction

func perform(map: Map) -> _Action:
	var current_zoom: Vector2 = map.camera.zoom
	var current_zoom_x: float = current_zoom.x

	if direction == ZoomDirection.OUT:
		if current_zoom_x >= .25:
			map.camera.zoom /= 2
	elif direction == ZoomDirection.IN:
		if current_zoom_x <= 2:
			map.camera.zoom *= 2

	return NoAction.new(entity)
