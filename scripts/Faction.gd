extends Resource
class_name Faction

# Basic faction properties
@export var name: String = ""
@export var spice: int = 0
@export var units_available: int = 0
@export var special_abilities: Array = []
@export var color: Color = Color.WHITE
@export var starting_regions: Array = []
