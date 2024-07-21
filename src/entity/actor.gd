class_name Actor extends _Entity

var fov

func _init() -> void:
	super("actor")

	fov = AdamMilazzoFov.new()
