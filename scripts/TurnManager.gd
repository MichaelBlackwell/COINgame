extends Node

signal turn_started(faction)
signal turn_ended(faction)

var current_faction = null
var eligible_factions = []

func start_turn(faction):
	current_faction = faction
	emit_signal("turn_started", faction)
	# Wait for player or AI action
	#await action_completed()
	emit_signal("turn_ended", faction)

func perform_ai_turn(faction):
	# Placeholder AI logic
	print("%s AI is taking turn..." % faction.name)
	#await get_tree().create_timer(1.0)  # simulate AI thinking
	emit_signal("turn_ended", faction)
