class_name Game extends Node2D

@onready var player: _Entity
@onready var input_handler: InputHandler = $InputHandler
@onready var map: Map = $Map
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	new_game()

func new_game() -> void:
	player = EntityLoader.create("player", {"position": {"x": 0, "y": 0}})
	remove_child(camera)

	map.init_map(30, 30, player, camera)
	map.generate()
	var player_position = player.components.position
	player.fov.compute(map, player_position.x, player_position.y, 5)
	player.fov.update_map()

	camera.make_current.call_deferred()

func _physics_process(_delta: float) -> void:
	var action: _Action = await input_handler.get_action(player, _delta)
	if action:
		var performed_action = action.perform(map)

		if performed_action is NoAction:
			return

		if performed_action is UnableToPerformAction:
			print(performed_action.reason)

		var player_position = player.components.position
		player.fov.compute(map, player_position.x, player_position.y, 5)
		player.fov.update_map()

		handle_enemy_turns()

func handle_enemy_turns() -> void:
	for entity in map.actors:
		if entity == player:
			continue

		print("The " + entity.name + " wonders when it will get to take a real turn.")
