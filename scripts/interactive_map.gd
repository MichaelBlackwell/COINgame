extends Node2D 

@onready var region_container = $Regions
@onready var operations = $Operations
@onready var factions = $Factions

@onready var label_region_name = $Canvas/Control/RegionInfoPanel/VBox/RegionName
@onready var label_faction = $Canvas/Control/RegionInfoPanel/VBox/FactionControl
@onready var label_spice = $Canvas/Control/RegionInfoPanel/VBox/SpiceValue
@onready var label_support = $Canvas/Control/RegionInfoPanel/VBox/SupportLevel
@onready var label_population = $Canvas/Control/RegionInfoPanel/VBox/Population

@onready var btn_move = $Canvas/Control/PanelContainer/VBox/OpButton_MoveTroops
@onready var btn_recruit = $Canvas/Control/PanelContainer/VBox/OpButton_Recruit
@onready var btn_recruit_elite = $Canvas/Control/PanelContainer/VBox/OpButton_RecruitElite
@onready var btn_harvest = $Canvas/Control/PanelContainer/VBox/OpButton_HarvestSpice
@onready var btn_attack = $Canvas/Control/PanelContainer/VBox/OpButton_Attack

var selected_faction = "Atreides" # Change dynamically per turn
var selected_region: Area2D = null
var active_operation: String = ""
var recruiting_elite = false
var recruitment_active = false


signal region_selected(selected_region)


func _ready():
	connect("region_selected", _on_region_selected)
	
	
	btn_recruit.pressed.connect(_on_recruit_pressed)
	btn_recruit_elite.pressed.connect(_on_recruit_elite_pressed)
	btn_move.pressed.connect(_on_move_pressed)
	btn_harvest.pressed.connect(_on_harvest_pressed)
	btn_attack.pressed.connect(_on_attack_pressed)
	
	setup_starting_pieces()
	
func setup_starting_pieces():
	var starting_pieces = [
		{"region": "Arrakeen", "faction": "Atreides", "type": "Troop"},
		{"region": "Arrakeen", "faction": "Atreides", "type": "Troop"},
		{"region": "Arrakeen", "faction": "Atreides", "type": "Troop"},
		{"region": "Tsimpo", "faction": "Atreides", "type": "Troop"},
		{"region": "Carthag", "faction": "Harkonnen", "type": "Troop"},
		{"region": "Carthag", "faction": "Harkonnen", "type": "Troop"},
		{"region": "Carthag", "faction": "Harkonnen", "type": "Troop"},
		{"region": "Arsunt", "faction": "Harkonnen", "type": "Troop"},
		{"region": "Highway 1", "faction": "Fremen", "type": "Guerrilla"},
		{"region": "Highway 2", "faction": "Fremen", "type": "Guerrilla"},
		{"region": "Highway 3", "faction": "Fremen", "type": "Guerrilla"},
		{"region": "Arrakeen", "faction": "Emperor", "type": "Elite"},
		{"region": "Carthag", "faction": "Emperor", "type": "Elite"}
	]
	
	for piece in starting_pieces:
		var region = get_region_by_name(piece["region"])
		if region:
			region.add_piece(piece["faction"], piece["type"])

func get_region_by_name(region_name):
	for region in region_container.get_children():
		if region.region_data.region_name == region_name:
			return region
	return null	

func _on_region_selected(region):
	selected_region = region
	update_ui_display(region)

func update_ui_display(region):
	selected_region = region
	
	label_region_name.text = region.region_data.region_name
	label_spice.text = "Spice: %d" % region.region_data.spice_value
	label_support.text = "Support Level: %d" % region.region_data.support_level
	label_faction.text = "Controlled by: %s" % region.region_data.controlling_faction
	label_population.text = "Population: %s" % region.region_data.population
	
	highlight_selected_region(region)
	
func highlight_selected_region(region):
	# First clear previous highlight
	for child in $Regions.get_children():
		child.highlight(false)
	
	# Highlight new region
	var selected_poly = region.get_node("Polygon2D")
	selected_region = region
	selected_region.highlight(true)
	

	


	
func highlight_valid_recruitment_zones():
	# Loop through all regions and check if they are valid recruitment spaces
	for region in $Regions.get_children():
		if operations.is_valid_recruitment_space(selected_faction, region):
			region.highlight(true)

func remove_highlight():
	for region in $Regions.get_children():
		region.highlight(false)


#begin operation to recruit but dont place a unit yet.
#See Region._input_event
func _on_recruit_pressed():
	recruitment_active = true
	toggle_operation("Recruit")

#called by Region._input_event for placing a unit
func execute_recruit(region: Area2D):
	if operations.is_valid_recruitment_space(selected_faction, region):
		operations.execute_operation(selected_faction, "Recruit", region, recruiting_elite)

	
func _on_recruit_elite_pressed():
	recruitment_active = true
	toggle_operation("Recruit Elite")

func _on_move_pressed():
	toggle_operation("Move Troops")

func _on_harvest_pressed():
	toggle_operation("Harvest Spice")

func _on_attack_pressed():
	toggle_operation("Attack")

func toggle_operation(operation: String):
	if active_operation == operation:
		cancel_active_operation()  # If already selected, cancel it
	else:
		start_operation(operation)
	
	
func start_operation(operation: String):
	active_operation = operation
	disable_other_operations(operation)

	# Highlight regions if recruiting
	if operation == "Recruit":
		highlight_valid_recruitment_zones()
		
func cancel_active_operation():
	active_operation = ""
	enable_all_operations()
	remove_highlight()
	recruitment_active = false

func disable_other_operations(except: String):
	btn_recruit.disabled = except != "Recruit"
	btn_recruit_elite.disabled = except != "Recruit Elite"
	btn_move.disabled = except != "Move Troops"
	btn_harvest.disabled = except != "Harvest Spice"
	btn_attack.disabled = except != "Attack"

func enable_all_operations():
	btn_recruit.disabled = false
	btn_recruit_elite.disabled = false
	btn_move.disabled = false
	btn_harvest.disabled = false
	btn_attack.disabled = false
	
	
