class_name Player
extends CharacterBody2D

@export var speed: int = 370
@export var maxhealth: int = 5
@export var knockback_power: int = 800  
@export var knockback_duration: float = 0.1 

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var effects: AnimationPlayer = $effects
@onready var hurt: Timer = $hurt
@onready var hurtbox: Area2D = $hurtbox

var currenthealth: int
var ishurt: bool = false
var knockback_vector: Vector2 = Vector2.ZERO

signal healthchanged

func _ready():
	add_to_group("player")
	currenthealth = maxhealth
	effects.play("RESET")

func _physics_process(_delta):
	handle_input()
	
	velocity += knockback_vector
	move_and_slide()
	
	update_animation()
	check_hurtbox()

func handle_input():
	if ishurt:
		velocity = Vector2.ZERO
	else:
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = input_dir * speed

func update_animation():
	if velocity.length() == 0 and knockback_vector.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0:
			direction = "Left"
		elif velocity.x > 0:
			direction = "Right"
		elif velocity.y < 0:
			direction = "Up"
		animations.play("walk_" + direction)

func check_hurtbox():
	if ishurt:
		return
	for area in hurtbox.get_overlapping_areas():
		if area.name == "hitbox":
			hurt_by_enemy(area)

func hurt_by_enemy(area):
	currenthealth -= 1
	if currenthealth < 0:
		currenthealth = maxhealth

	healthchanged.emit(currenthealth)
	effects.play("hurtblink")
	hurt.start()

	# Knockback away from the enemy
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

func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		area.collect()

func _on_hurtbox_area_exited(_area: Area2D) -> void:
	pass

#=========================================================
#
#class_name Player
#extends CharacterBody2D
#
#@export var speed = 370
#@onready var animations = $AnimationPlayer
#@export var maxhealth = 4
#@onready var currenthealth: int
#@onready var effects = $effects
#@onready var hurt = $hurt
#@onready var hurtbox = $hurtbox
#@onready var attacks = $scythe/AnimationPlayer2
#
#var lastanimdirection: String = "Left"
#var isattacking: bool = false
#
#@export var knockbackpower: int = 2000
#var ishurt: bool = false
#
#signal healthchanged
#
#func _ready():
	#add_to_group("player")
	#effects.play("RESET")
	#currenthealth = maxhealth
#
#func get_input():
	#var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#velocity = input_direction * speed
	#
	#if Input.is_action_just_pressed("attack"):
		#attacks.play("attackAOE")
		#isattacking = true
		#await attacks.animation_finished
		#isattacking = false
#
#func updateAnimation():
	#if isattacking: return
	#if velocity.length() == 0:
		#animations.stop()
	#else:
		#var direction = "Down"
		#if velocity.x < 0: direction = "Left"
		#elif velocity.x > 0: direction = "Right"
		#elif velocity.y < 0: direction = "Up"
		#animations.play("walk_" + direction)
#
		#lastanimdirection = direction
		#
		#
#func handleCollision():
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)  
		#var collider = collision.get_collider()   
		#print_debug(collider.name)
#
#
#func _physics_process(_delta):
	#get_input()
	#move_and_slide()
	#updateAnimation()
	#if !ishurt:
		#for area in hurtbox.get_overlapping_areas():
			#if area.name == "hitbox":
				#hurtbyenemy(area)
	#
#func hurtbyenemy(area):
	#currenthealth -= 1
	#if currenthealth < 0:
		#currenthealth = maxhealth
			#
	#healthchanged.emit(currenthealth)
	#ishurt = true
	#knockback(area.get_parent().velocity)
	#effects.play("hurtblink")
	#hurt.start()
	#await hurt.timeout
	#effects.play("RESET")
	#ishurt = false
#
#func _on_hurtbox_area_entered(area):
	#if area.has_method("collect"):
		#area.collect()
		#
#
#func knockback(enemyvelocity: Vector2):
	#var knockbackdirection = -(enemyvelocity - velocity).normalized() * knockbackpower
	#velocity = knockbackdirection
	#move_and_slide()
#
#
#func _on_hurtbox_area_exited(area: Area2D) -> void:
	#pass
