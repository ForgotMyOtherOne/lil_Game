extends Control

signal restart_requested
signal quit_requested

func _ready():
	hide()


func _on_restart_pressed() -> void:
	restart_requested.emit()


func _on_quit_pressed() -> void:
	quit_requested.emit()
