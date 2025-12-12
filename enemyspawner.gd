extends Node2D

@onready var spawn_point: Marker2D = $Marker2D
@onready var timer: Timer = $Timer

var skeleton_scene := preload("res://skeleton.tscn")

@export var spawn_interval := 5   

func _ready():
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	var skeleton := skeleton_scene.instantiate()
	skeleton.global_position = spawn_point.global_position
	get_parent().add_child(skeleton)
	print("spawn")
