class_name Fighter extends _ExportableComponent

@export var base_max_hp: int
var hp: int = base_max_hp
@export var base_defense: int
@export var base_power: int

func _init(json: Dictionary = {}) -> void:
	super(json, "fighter")

func setup_defaults() -> void:
	set_hp(base_max_hp)

func parse_json(json: Dictionary = {}) -> void:
	base_max_hp = json.base_max_hp
	hp = json.hp
	base_defense = json.base_defense
	base_power = json.base_power

func set_hp(value) -> void:
	hp = clampi(value, 0, base_max_hp)

	if hp <= 0:
		die()

func take_damage(amount: int) -> void:
	set_hp(hp - amount)

func die() -> void:
	print(parent_entity.name + " dies!")
