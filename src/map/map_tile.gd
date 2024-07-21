class_name MapTile extends Node2D

@onready var x: int
@onready var y: int
@onready var sprite: Sprite2D = $Sprite
@onready var entity: _Entity

func _ready() -> void:
	if entity:
		set_sprite(entity.sprite)
	set_tile_position()

func set_entity(_entity:_Entity) -> void:
	entity = _entity

func set_tile_position() -> void:
	if entity && entity.components.has("position"):
		var position:Position = entity.components.get("position")
		x = position.x
		y = position.y

		var x_offset = 0
		var y_offset = 0
		if entity.components.has("randomly_place"):
			var randomly_place: RandomlyPlace = entity.components.get("randomly_place")
			x_offset = randomly_place.x_offset
			y_offset = randomly_place.y_offset

		global_position = Vector2(x * 128 + x_offset, y * 128 + y_offset)

func set_sprite(texture:Texture2D) -> void:
	sprite.texture = texture

func _physics_process(delta: float) -> void:
	set_tile_position() # TODO: Update this once when position changes, not every physics process
