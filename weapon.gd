extends Area2D   # ← REQUIRED

@export var damage := 1
@export var hit_cooldown := 0.5

var recently_hit := {}

func _ready():
	add_to_group("player_attack")   # ← REQUIRED

func _physics_process(delta):
	for enemy in recently_hit.keys():
		recently_hit[enemy] -= delta
		if recently_hit[enemy] <= 0:
			recently_hit.erase(enemy)

func _on_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent()
	if enemy.has_method("take_damage"):
		if enemy in recently_hit:
			return

		enemy.take_damage(damage)
		recently_hit[enemy] = hit_cooldown
