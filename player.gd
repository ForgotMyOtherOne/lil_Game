class_name Player
extends CharacterBody2D

@export var speed = 370
@onready var animations = $AnimationPlayer
@export var maxhealth = 4
@onready var currenthealth: int = maxhealth
@onready var effects = $effects
@onready var hurt = $hurt
var enemycollision = []


@export var knockbackpower: int = 2000
var ishurt: bool = false

signal healthchanged

func _ready():
	add_to_group("player")
	effects.play("RESET")

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

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)  
		var collider = collision.get_collider()   
		print_debug(collider.name)


func _physics_process(_delta):
	get_input()
	move_and_slide()
	updateAnimation()
	if !ishurt:
		for enemyarea in enemycollision:
			hurtbyenemy(enemyarea)
	
func hurtbyenemy(area):
	currenthealth -= 1
	if currenthealth < 0:
		currenthealth = maxhealth
			
	healthchanged.emit(currenthealth)
	ishurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurtblink")
	hurt.start()
	await hurt.timeout
	effects.play("RESET")
	ishurt = false

func _on_hurtbox_area_entered(area):
	if area.name == "hitbox":
		enemycollision.append(area)
		

func knockback(enemyvelocity: Vector2):
	var knockbackdirection = -(enemyvelocity - velocity).normalized() * knockbackpower
	velocity = knockbackdirection
	move_and_slide()


func _on_hurtbox_area_exited(area: Area2D) -> void:
	enemycollision.erase(area)
