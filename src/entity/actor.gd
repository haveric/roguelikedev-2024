class_name Actor extends _Entity

var fov

func _init() -> void:
	super("actor")

	fov = AdamMilazzoFov.new()

func is_alive() -> bool:
	var fighter: Fighter = components.get("fighter")
	return fighter && fighter.hp > 0
