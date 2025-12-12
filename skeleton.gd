extends CharacterBody2D

@onready var anim := $AnimatedSprite2D

@export var speed := 100.0
@export var wander_change_interval := 2.5
@export var initial_drop_time := 1.5

var direction := Vector2.ZERO
var wandering := false

func _ready():
	direction = Vector2.DOWN
	wandering = false

	# Play initial animation
	_play_animation()

	await get_tree().create_timer(initial_drop_time).timeout
	_start_wandering()


func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()

	_play_animation()  # update animation every frame based on current direction


func _start_wandering():
	wandering = true
	_change_direction()
	_wander_loop()


func _wander_loop() -> void:
	while wandering:
		await get_tree().create_timer(wander_change_interval).timeout
		_change_direction()


func _change_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()
	_play_animation()


func _play_animation():
	# Determine animation name based on direction
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("walkRight")
		else:
			anim.play("walkLeft")
	else:
		if direction.y > 0:
			anim.play("walkDown")
		else:
			anim.play("walkUp")
