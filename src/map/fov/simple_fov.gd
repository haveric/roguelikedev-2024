class_name SimpleFov extends _BaseFov

func compute(map: Map, x: int, y: int, radius: int) -> void:
	super(map, x, y, radius)

	for i in range(rect.position.x, rect.end.x + 1):
		for j in range(rect.position.y, rect.end.y + 1):
			explore_tile(map, i, j)
