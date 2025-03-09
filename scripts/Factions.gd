extends Node

var factions = {
	"Atreides": {"spice": 20},
	"Harkonnen": {"spice": 30},
	"Fremen": {"spice": 15},
	"Emperor": {"spice": 40}
}

func add_spice_to_faction(faction, amount):
	factions[faction]["spice"] += amount
	print("%s now has %d spice" % [faction, factions[faction]["spice"]])

func can_afford_operation(faction, cost):
	return factions[faction]["spice"] >= cost
