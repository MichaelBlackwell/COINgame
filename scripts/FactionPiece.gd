extends Node2D

@export var faction: String = "Neutral"
@export var piece_type: String = "Troop"
@export var region_name: String = ""

@onready var sprite = $Sprite2D
@onready var area = $Area2D

var dragging = false

var faction_colors = {
	"Atreides": Color.GREEN,
	"Harkonnen": Color.RED,
	"Fremen": Color.ORANGE,
	"Emperor": Color.PURPLE
}

func _ready():
	update_visual()
	area.input_event.connect(_on_piece_clicked)  # Connect click signal

func update_visual():
	# Change color based on faction
	sprite.self_modulate = faction_colors.get(faction, Color.GRAY)

	# Different shapes based on piece type
	match piece_type:
		"Troop": sprite.scale = Vector2(1,1)  # Normal cube
		"Elite": sprite.scale = Vector2(1.2,1.2)  # Slightly larger for elite troops
		"Guerrilla": sprite.scale = Vector2(0.8,0.8)  # Smaller for insurgents
		"Leader": sprite.scale = Vector2(1.5,1.5)  # Largest for commanders

func move_to_region(new_region_name):
	region_name = new_region_name
	position = get_tree().get_root().find_child(new_region_name, true, false).position

func _on_piece_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		#dragging = true
		print("Clicked on", faction, piece_type, "in", region_name)
	#elif event is InputEventMouseButton and !event.pressed:
		#dragging = false

#func _process(delta):
	#if dragging:
	#	position = get_global_mouse_position()
