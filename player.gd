extends CharacterBody2D

@export var speed = 370
@onready var animations = $AnimationPlayer
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		animations.play("walk_" + direction)

func _physics_process(_delta):
	get_input()
	move_and_slide()
	updateAnimation()
