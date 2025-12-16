class_name Player
extends CharacterBody2D



@export var speed: int = 370
@export var maxhealth: int = 5
@export var knockback_power: int = 800
@export var knockback_duration: float = 0.1

@onready var hurt2: AudioStreamPlayer2D = $hurt2
@onready var walkingplayer: AudioStreamPlayer2D = $walkingplayer


@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var effects: AnimationPlayer = $effects
@onready var hurt: Timer = $hurt
@onready var hurtbox: Area2D = $hurtbox
@onready var attacks: AnimationPlayer = $attacks




var currenthealth: int
var ishurt := false
var knockback_vector := Vector2.ZERO
var lastanimdir := "Down"
var dead := false


signal healthchanged(new_health: int)
signal died


func _ready():
	add_to_group("player")
	currenthealth = maxhealth
	effects.play("RESET")


func _physics_process(_delta):
	if dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	handle_input()

	velocity += knockback_vector
	move_and_slide()

	update_animation()
	check_hurtbox()



func handle_input():
	# ATTACK
	if Input.is_action_just_pressed("attack"):
		attacks.play("attack" + lastanimdir)

	if ishurt:
		velocity = Vector2.ZERO
	else:
		var input_dir = Input.get_vector(
			"ui_left", "ui_right",
			"ui_up", "ui_down"
		)
		velocity = input_dir * speed

		if input_dir != Vector2.ZERO:
			_play_walking_sound()
		else:
			_stop_walking_sound()
			

func _play_walking_sound():
	if not walkingplayer.playing:
		walkingplayer.play()

func _stop_walking_sound():
	if walkingplayer.playing:
		walkingplayer.stop()



func update_animation():
	if velocity.length() == 0 and knockback_vector.length() == 0:
		animations.stop()
		return

	var direction := "Down"

	if abs(velocity.x) > abs(velocity.y):
		direction = "Right" if velocity.x > 0 else "Left"
	else:
		direction = "Down" if velocity.y > 0 else "Up"

	animations.play("walk_" + direction)
	lastanimdir = direction

# HURT =========
func check_hurtbox():
	if ishurt or dead:
		return

	for area in hurtbox.get_overlapping_areas():
		if area.name == "hitbox":
			hurt_by_enemy(area)
			break

func hurt_by_enemy(area: Area2D):
	if dead:
		return

	currenthealth -= 1
	healthchanged.emit(currenthealth)

	if currenthealth <= 0:
		_die()
		return

	effects.play("hurtblink")
	hurt2.play()
	hurt.start()

	# Knockback
	var enemy_pos = area.get_parent().global_position
	var knock_dir = (global_position - enemy_pos).normalized() * knockback_power
	apply_knockback(knock_dir)

	await hurt.timeout
	effects.play("RESET")

func apply_knockback(direction: Vector2):
	ishurt = true
	knockback_vector = direction
	await get_tree().create_timer(knockback_duration).timeout
	knockback_vector = Vector2.ZERO
	ishurt = false

# DEATH
func _die():
	dead = true
	velocity = Vector2.ZERO
	knockback_vector = Vector2.ZERO
	animations.stop()
	effects.play("RESET")
	died.emit()

# PICKUPS
func _on_hurtbox_area_entered(area: Area2D):
	if area.has_method("collect"):
		area.collect()
