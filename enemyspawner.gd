extends Node2D

@onready var spawn_point: Marker2D = $Marker2D
@onready var cycle_timer: Timer = $CycleTimer
@onready var spawn_timer: Timer = $SpawnTimer

@export var skeleton_scene: PackedScene

# -------------------------
# TIMING
# -------------------------
@export var active_time := 50     # seconds per wave (you said 5)
@export var rest_time := 10.0      # rest between waves
@export var spawn_interval := 1.0  # time between spawns

# -------------------------
# WAVE SETTINGS
# -------------------------
@export var base_spawn_amount := 1
@export var spawn_increase_per_wave := 1

var wave: int = 0
var spawning_active := false
var spawned_enemies: Array[Node] = []

# -------------------------
# READY
# -------------------------
func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	cycle_timer.one_shot = true

	# IMPORTANT: wait one frame so the tree is ready
	await get_tree().process_frame
	_start_wave()

# -------------------------
# WAVE CONTROL
# -------------------------
func _start_wave():
	wave += 1
	spawning_active = true

	print("WAVE", wave, "START")

	spawn_timer.start()

	cycle_timer.wait_time = active_time
	cycle_timer.timeout.connect(_end_wave, CONNECT_ONE_SHOT)
	cycle_timer.start()

func _end_wave():
	print("WAVE", wave, "END")

	spawning_active = false
	spawn_timer.stop()

	_clear_enemies()

	cycle_timer.wait_time = rest_time
	cycle_timer.timeout.connect(_start_wave, CONNECT_ONE_SHOT)
	cycle_timer.start()

# -------------------------
# SPAWNING
# -------------------------
func _on_spawn_timer_timeout():
	if not spawning_active:
		return

	var spawn_amount := base_spawn_amount + (wave - 1) * spawn_increase_per_wave
	print("Spawning", spawn_amount, "enemies")

	for i in range(spawn_amount):
		var enemy := skeleton_scene.instantiate()
		enemy.global_position = spawn_point.global_position

		# THIS IS THE FIX (prevents the crash)
		get_parent().add_child.call_deferred(enemy)

		spawned_enemies.append(enemy)

# -------------------------
# CLEANUP
# -------------------------
func _clear_enemies():
	for enemy in spawned_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()

	spawned_enemies.clear()
