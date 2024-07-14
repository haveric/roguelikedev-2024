class_name Game extends Node2D

@onready var player: _Entity
@onready var input_handler: InputHandler = $InputHandler
@onready var map: Map = $Map

func _ready() -> void:
	new_game()

func new_game() -> void:
	player = EntityLoader.create("player", {"position": {"x": 15, "y": 9}})

	map.init_map(30, 17, player)
	map.generate()

func _physics_process(_delta: float) -> void:
	var action: _Action = await input_handler.get_action(player)
	if action:
		action.perform()
