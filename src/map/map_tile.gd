class_name MapTile extends Node2D

@onready var x: int
@onready var y: int
@onready var sprite: Sprite2D = $Sprite
@onready var entity: _Entity

func _ready() -> void:
	set_sprite(entity.sprite)
	set_tile_position()

func set_entity(_entity:_Entity) -> void:
	entity = _entity

func set_tile_position() -> void:
	if entity.components.has("position"):
		var position:Position = entity.components.get("position")
		x = position.x
		y = position.y

		global_position = Vector2(x * 64, y * 64)

func set_sprite(texture:Texture2D) -> void:
	sprite.texture = texture

func _physics_process(delta: float) -> void:
	set_tile_position() # TODO: Update this once when position changes, not every physics process
