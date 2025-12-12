extends BaseScene

@onready var heartscontainer = $CanvasLayer/heartscontainer
@onready var player = $player


func _ready():
	heartscontainer.setmaxheart(player.maxhealth)
	heartscontainer.updatehearts(player.currenthealth)
	player.healthchanged.connect(heartscontainer.updatehearts)
	
func _process(_delta):
	pass
