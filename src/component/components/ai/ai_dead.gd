class_name AIDead extends _AI

var previous_ai: String

func _init(json: Dictionary = {}) -> void:
	super(json, "ai_dead")

func parse_json(json: Dictionary = {}) -> void:
	previous_ai = json.previous_ai

func perform(map: Map) -> void:
	pass # Do nothing
