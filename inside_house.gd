extends Node2D

func _ready():
	var p = scene_manager.player
	if p:
		add_child(p)

		var spawn := $PlayerSpawn
		if spawn:
			p.global_position = spawn.global_position
