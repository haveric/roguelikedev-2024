class_name Faction extends _ExportableComponent

@export var factions: Array[String] = []
@export var enemies: Array[String] = []

func _init(json: Dictionary = {}) -> void:
	super(json, "faction")

func parse_json(json: Dictionary = {}) -> void:
	if json.has("factions"):
		factions = json.factions
	if json.has("enemies"):
		enemies = json.enemies

func is_enemy_of(other_faction: Faction) -> bool:
	if !other_faction:
		return false

	for faction in factions:
		if other_faction.enemies.has(faction):
			return true

	return false
