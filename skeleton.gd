extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $hurtbox

@export var speed := 200.0
@export var wander_change_interval := 2.5
@export var initial_drop_time := 1.5
@export var maxhealth := 2

var currenthealth: int
var player: Node2D = null
var playerchase := false
var direction := Vector2.ZERO
var wandering := false
var can_move := false   # <-- ADDED

func _ready():
	currenthealth = maxhealth
	direction = Vector2.ZERO
	_play_animation()

	# ---- IMPORTANT: wait ONE frame before moving ----
	await get_tree().process_frame
	can_move = true

	await get_tree().create_timer(initial_drop_time).timeout
	_start_wandering()

func _physics_process(_delta):
	if not can_move:
		return

	# Movement / chasing
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

func _exit_tree():
	if get_parent().has_method("on_enemy_removed"):
		get_parent().on_enemy_removed(self)


# -------------------------
#func _on_hurtbox_area_entered(area: Area2D) -> void:
	#if area.is_in_group("player_attack"):  # group you assign to player's attack hitbox
		#take_damage(1)
#
#func take_damage(amount: int = 1) -> void:
	#currenthealth -= amount
	#if currenthealth <= 0:
		#queue_free()  # dies
