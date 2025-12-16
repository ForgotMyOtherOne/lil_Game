extends Control

@onready var root := $"../../.."

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_pressed() -> void:
	root.pause_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()
