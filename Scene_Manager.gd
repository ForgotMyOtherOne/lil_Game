class_name SceneManager
extends Node

var player: Player
var first_load := true
var last_scene_name := ""

const SCENE_DIR := "res://"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("SceneManager: No player in 'player' group!")
		return


func change_scene(to_scene_name: String) -> void:
	if not player:
		push_error("SceneManager: player is null")
		return

	var current_scene := get_tree().current_scene
	if current_scene:
		# Save where we are coming from
		if first_load:
			last_scene_name = "Start"      # <--- DEFAULT FIRST SPAWN MARKER
			first_load = false
		else:
			last_scene_name = current_scene.name
	else:
		last_scene_name = "Start"

	# Remove the player before switching
	if player.get_parent():
		player.get_parent().remove_child(player)

	var full_path = SCENE_DIR + to_scene_name + ".tscn"
	call_deferred("_finish_scene_change", full_path)


func _finish_scene_change(full_path: String) -> void:
	get_tree().change_scene_to_file(full_path)
#==========================================================
#
#class_name SceneManager
#extends Node
#
#var player: Player
#var first_load := true
#var last_scene_name := ""
#
#const SCENE_DIR := "res://"
#
#func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player")
	#if not player:
		#push_error("SceneManager: No player in group 'player'")
		#return
#
#
#func change_scene(to_scene_name: String) -> void:
	#if not player:
		#push_error("SceneManager: player is null")
		#return
#
	#var current_scene := get_tree().current_scene
	#if current_scene:
		#last_scene_name = current_scene.name
#
	## Remove player from old scene
	#if player.get_parent():
		#player.get_parent().remove_child(player)
#
	#var full_path := SCENE_DIR + to_scene_name + ".tscn"
	#call_deferred("_finish_scene_change", full_path)
#
#
#func _finish_scene_change(full_path: String):
	## Change scene
	#get_tree().change_scene_to_file(full_path)
#
	## Wait one frame, then add the player to the root
	#await get_tree().process_frame
#
	#get_tree().current_scene.add_child(player)
	#player.owner = get_tree().current_scene
#
#
#
#
#




#var scene_dir_path = "res://"
#
#func change_scene(to_scene_name: String) -> void:
	#var from = get_tree().current_scene
	#last_scene_name = from.name
	#player = from.player
	#player.get_parent().remove_child(player)
#
	#var full_path = scene_dir_path + to_scene_name + ".tscn"
	#from.get_tree().call_deferred("change_scene_to_file", full_path)






#var player: Player
#var scene_dir := "res://"
#
#func _ready():
	#player = get_tree().get_first_node_in_group("player")
#
#
#func change_scene(to_scene: String) -> void:
	#if not player:
		#push_error("Player not found!")
		#return
#
	#if player.get_parent():
		#player.get_parent().remove_child(player)
#
	#var new_path := scene_dir + to_scene + ".tscn"
#
	#call_deferred("_finish_scene_change", new_path)
#
#
#func _finish_scene_change(new_path: String) -> void:
	#get_tree().change_scene_to_file(new_path)
#
	#await get_tree().process_frame
	#await get_tree().process_frame
#
	#var new_scene = get_tree().current_scene
	#new_scene.add_child(player)
#
	#if new_scene is BaseScene:
		#new_scene.position_player()
