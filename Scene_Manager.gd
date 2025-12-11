class_name SceneManager
extends Node

var player: Player
var scene_dir := "res://"

func _ready():
	player = get_tree().get_first_node_in_group("player")


func change_scene(to_scene: String) -> void:
	if not player:
		push_error("Player not found!")
		return

	# Remove player from old scene BEFORE loading
	if player.get_parent():
		player.get_parent().remove_child(player)

	var new_path := scene_dir + to_scene + ".tscn"

	# DEFER the scene load so Godot can finish the current frame
	call_deferred("_finish_scene_change", new_path)


func _finish_scene_change(new_path: String) -> void:
	get_tree().change_scene_to_file(new_path)
