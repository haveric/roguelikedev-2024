class_name MainGameEventHandler extends _EventHandler

const directions = {
	"move_up": Vector2i.UP,
	"move_down": Vector2i.DOWN,
	"move_left": Vector2i.LEFT,
	"move_right": Vector2i.RIGHT,
	"move_up_left": Vector2i.UP + Vector2i.LEFT,
	"move_up_right": Vector2i.UP + Vector2i.RIGHT,
	"move_down_left": Vector2i.DOWN + Vector2i.LEFT,
	"move_down_right": Vector2i.DOWN + Vector2i.RIGHT
}

func get_action(player: _Entity) -> _Action:
	var action: _Action = null

	for direction in directions:
		if Input.is_action_just_pressed(direction):
			var offset: Vector2i = directions[direction]
			action = MovementAction.new(player, offset.x, offset.y)

	if Input.is_action_just_pressed("zoom_out"):
		return ZoomAction.new(player, ZoomAction.ZoomDirection.OUT)
	if Input.is_action_just_pressed("zoom_in"):
		return ZoomAction.new(player, ZoomAction.ZoomDirection.IN)

	if Input.is_action_just_pressed("debug_gen"):
		action = DebugAction1.new(player)

	return action
