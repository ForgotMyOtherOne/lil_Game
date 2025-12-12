#class_name BaseScene
#extends Node
#
#@onready var entrance_markers: Node2D = $EntranceMarkers
#
#func _ready():
	#if scene_manager.player:
		#position_player()
	#else:
		#push_error("BaseScene: No player found in scene_manager!")
#
#func position_player() -> void:
	#var player = scene_manager.player
#
	#var target_marker_name = scene_manager.last_scene_name
	#if target_marker_name.is_empty():
		#target_marker_name = "Start"
#
	#for entrance in entrance_markers.get_children():
		#if entrance is Marker2D and entrance.name == target_marker_name:
			#player.global_position = entrance.global_position
			#add_child(player)              # <—— THIS fixes the respawn position!!
			#return
#
	#push_warning("No marker found for: " + target_marker_name)
	#add_child(player)                      # <—— fallback (still required)

class_name BaseScene
extends Node2D   # Use Node2D so `global_position` exists

@onready var entrance_markers := $EntranceMarkers

func _ready() -> void:
	if not scene_manager.player:
		push_error("BaseScene: No player in scene_manager!")
		return
		
	position_player()


func position_player() -> void:
	var player := scene_manager.player
	var last_scene := scene_manager.last_scene_name

	# --- FIRST LOAD ---
	if scene_manager.first_load:
		scene_manager.first_load = false
		var start_marker := entrance_markers.get_node_or_null("Start")
		if start_marker:
			player.global_position = start_marker.global_position
			return
		# fallback if Start doesn’t exist
		player.global_position = entrance_markers.get_child(0).global_position
		return

	# --- NORMAL SCENE ENTRY ---
	for marker in entrance_markers.get_children():
		if marker is Marker2D:
			if marker.name == last_scene:
				player.global_position = marker.global_position
				return

	# fallback if no matching marker found
	player.global_position = entrance_markers.get_child(0).global_position
