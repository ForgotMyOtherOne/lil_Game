extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@export var speed := 120.0
@export var wander_change_interval := 2.5
@export var initial_drop_time := 1.5

var justachange: bool = false


var player: Node2D = null
var playerchase := false
var direction := Vector2.ZERO
var wandering := false

func _ready():
	direction = Vector2.DOWN
	_play_animation()

	await get_tree().create_timer(initial_drop_time).timeout
	_start_wandering()

func _physics_process(_delta):
	if playerchase and player:
		direction = (player.global_position - global_position).normalized()

	velocity = direction * speed
	move_and_slide()
	_play_animation()

# -------------------------
# Movement / wandering
# -------------------------

func _start_wandering():
	wandering = true
	_change_direction()
	_wander_loop()

func _wander_loop() -> void:
	while wandering:
		if playerchase:
			await get_tree().create_timer(0.1).timeout
			continue

		await get_tree().create_timer(wander_change_interval).timeout
		_change_direction()

func _change_direction():
	var angle := randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()

func _play_animation():
	if velocity.length() == 0:
		return

	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			anim.play("walkRight")
		else:
			anim.play("walkLeft")
	else:
		if velocity.y > 0:
			anim.play("walkDown")
		else:
			anim.play("walkUp")

# -------------------------
# Player detection
# -------------------------

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		playerchase = true

func _on_detection_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		playerchase = false
