extends CharacterBody2D

@export var speed := 100.0
@export var wander_change_interval := 2.5   
@export var initial_drop_time := 1.5        

var direction := Vector2.ZERO
var wandering := false

func _ready():
	direction = Vector2.DOWN
	wandering = false
	
	await get_tree().create_timer(initial_drop_time).timeout
	_start_wandering()


func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()


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
