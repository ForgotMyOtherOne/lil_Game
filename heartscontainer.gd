extends HBoxContainer

@onready var heartguiclass = preload("res://panel.tscn")


func _ready():
	pass
	
func _process(_delta):
	pass

func setmaxheart(max: int):
	for i in range(max):
		var heart = heartguiclass.instantiate()
		add_child(heart)

func updatehearts(currenthealth: int):
	var hearts = get_children()
		
	for i in range(currenthealth):
		hearts[i].update(true)
			
	for i in range(currenthealth, hearts.size()):
		hearts[i].update(false)
