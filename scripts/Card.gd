extends Resource
class_name Card

@export var title: String
@export_multiline var flavor: String
@export_multiline var description: String
@export var faction_priority: Array[String] = []
@export var card_id: int = 0

func apply_event(game_state):
	# Placeholder for event logic; override per card if needed
	pass
