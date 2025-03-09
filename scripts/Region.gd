extends Area2D

@export var region_data: RegionData
@onready var piece_container = $PieceContainer


@onready var collision_polygon = $CollisionPolygon2D
@onready var highlight_polygon = $Polygon2D
@onready var name_label = $LabelName

const RANDOM_BUMP_RANGE = 30

var highlight_active = false

var interactive_map = null

func _ready():
	interactive_map = get_tree().get_root().find_child("InteractiveMap", true, false)
	highlight_polygon.polygon = collision_polygon.polygon
	highlight(false)
	
	update_resource_display()

func update_resource_display():
	if region_data.economic_value > 0:
		name_label.text = "%s\n🪙 %d" % [region_data.region_name, region_data.economic_value]
	else:
		name_label.text = "%s\n👨‍👩‍👧‍👦 %d | 🌶️ %d | ❤️ %d" % [region_data.region_name, region_data.population, region_data.spice_value, region_data.support_level]
	update_faction_color()

func highlight(enable: bool):
	highlight_active = enable
	if enable:
		highlight_polygon.modulate = Color(1, 1, 0.5, 0.6)  # Yellow tint for recruitable regions
	else:
		highlight_polygon.modulate = Color(1,1,1,0)  # Reset color when not highlighted

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if highlight_active and interactive_map.recruitment_active:
			interactive_map.execute_recruit(self)  # Tell the map to process the recruit
		else:
			get_parent().get_parent().emit_signal("region_selected", self)

func update_faction_color():
	var faction_colors = {
		1: Color.GREEN,
		2: Color(0.7,0,0),
		0: Color.GRAY
	}
	$Polygon2D.color = faction_colors.get(region_data.controlling_faction)

func add_piece(faction: String, piece_type: String):
	var piece_scene = preload("res://scenes/FactionPiece.tscn")
	var piece_instance = piece_scene.instantiate()
	
	piece_instance.faction = faction
	piece_instance.piece_type = piece_type
	piece_instance.region_name = region_data.region_name
	piece_instance.position = Vector2(randi_range(-RANDOM_BUMP_RANGE,RANDOM_BUMP_RANGE), randi_range(-RANDOM_BUMP_RANGE,RANDOM_BUMP_RANGE))  # Slight offset for stacking pieces
	
	piece_container.add_child(piece_instance)
	piece_instance.update_visual()

func remove_piece(piece):
	piece.queue_free()

func get_piece_of_faction(faction):
	for piece in piece_container.get_children():
		if piece.faction == faction:
			return piece
	return null

func get_enemy_pieces(faction):
	var enemy_pieces = []
	for piece in piece_container.get_children():
		if piece.faction != faction:
			enemy_pieces.append(piece)
	return enemy_pieces
