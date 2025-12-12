class_name SceneManager
extends Node

var player: Player
var last_scene_name: String

const SCENE_DIR := "res://"

func _ready():
	# Player is always in group "player"
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("SceneManager: No player found in group 'player'")
		return

func change_scene(to_scene_name: String) -> void:
	if not player:
		push_error("SceneManager: player is null!")
		return

	var current_scene = get_tree().current_scene
	if not current_scene:
		push_error("SceneManager: current scene is null")
		return

	last_scene_name = current_scene.name

	# Remove player from the current scene
	if player.get_parent():
		player.get_parent().remove_child(player)

	var full_path = SCENE_DIR + to_scene_name + ".tscn"
	call_deferred("_finish_scene_change", full_path)

func _finish_scene_change(full_path: String) -> void:
	get_tree().change_scene_to_file(full_path)
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
