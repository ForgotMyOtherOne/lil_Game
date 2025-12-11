class_name SceneTrigger
extends Area2D

@export var target_scene: String


func _on_body_entered(body):
	if body is Player:
		scene_manager.change_scene(target_scene)
