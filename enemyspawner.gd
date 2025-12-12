extends Node2D

@onready var main = get_node(".")
var skeleton_scene := preload("res://skeleton.tscn")
var spawn_points: Array[Marker2D] = []

func _ready():
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child)

func _on_timer_timeout():
	if spawn_points.is_empty():
		push_warning("No spawn points!")
		return

	var spawn_point = spawn_points[randi() % spawn_points.size()]
	var skeleton = skeleton_scene.instantiate()
	skeleton.position = spawn_point.position
	main.add_child(skeleton)
