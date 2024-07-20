class_name Game extends Node2D

@onready var player: _Entity
@onready var input_handler: InputHandler = $InputHandler
@onready var map: Map = $Map
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	new_game()

func new_game() -> void:
	player = EntityLoader.create("player", {"position": {"x": 15, "y": 9}})
	remove_child(camera)

	map.init_map(30, 17, player, camera)
	map.generate()

	camera.make_current.call_deferred()

func _physics_process(_delta: float) -> void:
	var action: _Action = await input_handler.get_action(player, _delta)
	if action:
		var performed_action = action.perform(map)

		if performed_action is NoAction:
			return

		if performed_action is UnableToPerformAction:
			print(performed_action.reason)
