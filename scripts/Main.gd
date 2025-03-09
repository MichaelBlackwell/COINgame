extends Node2D

@onready var turn_manager = $TurnManager

@onready var current_title = $Canvas/UI/Lower/CurrentCard/VBox/Label_Title
@onready var current_description = $Canvas/UI/Lower/CurrentCard/VBox/Label_Description
@onready var current_flavor = $Canvas/UI/Lower/CurrentCard/VBox/Label_Flavor
@onready var next_title = $Canvas/UI/Lower/NextCard/VBox/Label_Title
@onready var next_description = $Canvas/UI/Lower/NextCard/VBox/Label_Description
@onready var next_flavor = $Canvas/UI/Lower/NextCard/VBox/Label_Flavor

func _ready():
	await get_tree().process_frame
	#load resources
	GameManager.factions = preload_factions()
	GameManager.card_deck = preload_all_cards()
	GameManager.regions = preload_all_regions()
	

	#Setup
	GameManager.card_deck.shuffle()
	GameManager.current_card = draw_card()
	GameManager.next_card = draw_card()
	display_card(GameManager.current_card, GameManager.next_card)
	
	#Start turn
	#turn_loop()

func preload_factions():
	var atreides = load("res://resources/factions/atreides.tres")
	var harkonnen = load("res://resources/factions/harkonnen.tres")
	return [atreides, harkonnen]

func preload_all_cards():
	var cards = []
	var dir = DirAccess.open("res://resources/cards/")
	if dir:
		for file in dir.get_files():
			if file.get_extension() == "tres":
				cards.append(load("res://resources/cards/%s" % file))
	return cards
	
func preload_all_regions():
	var regions = []
	var dir = DirAccess.open("res://resources/regions/")
	if dir:
		for file in dir.get_files():
			if file.get_extension() == "tres":
				regions.append(load("res://resources/regions/%s" % file))
	return regions

func turn_loop():
	while not check_victory_conditions():
		GameManager.current_card = draw_card()
		GameManager.next_card = GameManager.card_deck.front()  # peek at next card

		

		#var eligible_factions = get_eligible_factions(GameManager.current_card)
		#for faction in eligible_factions:
			#handle_faction_turn(faction, GameManager.current_card)

		#await turn_status.completed  # proceed after turn finishes

func display_card(cur_card, nex_card):
	current_title.text = cur_card.title
	current_description.text = cur_card.description
	current_flavor.text = cur_card.flavor
	next_title.text = nex_card.title
	next_description.text = nex_card.description
	next_flavor.text = nex_card.flavor

#func turn_phase():
	#var eligible_factions = get_eligible_factions(GameManager.current_card)
	#for faction in eligible_factions:
		#faction_take_turn(faction)

func draw_card():
	# Placeholder for drawing a card from a shuffled deck
	return GameManager.card_deck.pop_front()

func get_eligible_factions(card):
	# Logic determining eligible factions based on card metadata
	return GameManager.factions

func check_victory_conditions():
	return false  # placeholder
	
#Example RPC method to sync player actions
#@rpc
#func rpc_player_move(faction_name, from_region, to_region):
	# Move units on all clients
	#move_units(faction_name, from_region, to_region)

#Invoke on move action:
#func player_move(faction_name, from_region, to_region):
#	rpc("rpc_player_move", faction_name, from_region, to_region)
