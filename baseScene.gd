class_name BaseScene
extends Node

@onready var entrance_markers: Node2D = $EntranceMarkers

func _ready():
	# Player should already be moved into this scene by SceneManager
	if scene_manager.player:
		position_player()
	else:
		push_error("BaseScene: No player found in scene_manager!")


func position_player() -> void:
	var last_scene = scene_manager.last_scene_name
	if last_scene.is_empty():
		last_scene = "outside"
	#if not scene_manager.player:
		#return
		#
		#
#
	var player = scene_manager.player

	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "Outside" or entrance.name == last_scene:
			player.global_position = entrance.global_position
