extends Node

signal operation_completed(faction, operation, region)

@onready var map = $"../../InteractiveMap"

func execute_operation(faction: String, operation: String, region: Area2D, elite: bool = false):
	match operation:
		"Move Troops":
			move_troops(faction, region)
		"Recruit":
			recruit_units(faction, region, elite)
		"Harvest Spice":
			harvest_spice(faction, region)
		"Attack":
			attack_enemy(faction, region)

	emit_signal("operation_completed", faction, operation, region)

func move_troops(faction, region):
	print("%s is moving troops to %s" % [faction, region.region_data.region_name])

	# Find a friendly region with troops
	var source_region = map.get_region_with_faction_troops(faction)
	if source_region:
		var piece = source_region.get_piece_of_faction(faction)
		if piece:
			source_region.remove_piece(piece)
			region.add_piece(faction, "Troop")

func recruit_units(faction, region, elite):
	var cost = 1  # Base cost
	if elite:
		cost += 1  # Extra cost for elite troop

	# Check if faction can afford the operation
	if !map.factions.can_afford_operation(faction, cost):
		print("❌ Not enough spice to recruit in", region.region_data.region_name)
		return

	# Validate recruitment location
	if is_valid_recruitment_space(faction, region):
		map.factions.add_spice_to_faction(faction, -cost)
		region.add_piece(faction, "Elite" if elite else "Troop")
		print("✅", faction, "recruited", "Elite" if elite else "Troop", "in", region.region_data.region_name)
	else:
		print("❌ Cannot recruit in", region.region_data.region_name, "due to restrictions.")

func is_valid_recruitment_space(faction, region):
	var region_data = region.region_data

	# General rule: Populated spaces WITH Support
	if region_data.population > 0 and region_data.support_level == 1:
		return true

	# Special rule: Fremen can recruit in any Neutral space on Arrakis
	if faction == "Fremen" and region_data.controlling_faction == "Neutral":
		return true

	return false

func harvest_spice(faction, region):
	print("%s is harvesting spice in %s" % [faction, region.region_data.region_name])
	var new_resources = region.region_data.spice_value * 2
	map.add_spice_to_faction(faction, new_resources)

func attack_enemy(faction, region):
	print("%s is attacking in %s" % [faction, region.region_data.region_name])
	var enemy_pieces = region.get_enemy_pieces(faction)
	if enemy_pieces.size() > 0:
		var enemy_piece = enemy_pieces.pick_random()
		region.remove_piece(enemy_piece)
