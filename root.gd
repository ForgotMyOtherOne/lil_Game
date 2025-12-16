#extends BaseScene
#
#@onready var heartscontainer = $CanvasLayer/heartscontainer
#@onready var player: Player = $player
#@onready var pausemenu = $player/Camera2D2/Pausemenu
#
#var paused := false
#
#func _ready():
	#heartscontainer.setmaxheart(player.maxhealth)
	#heartscontainer.updatehearts(player.currenthealth)
	#player.healthchanged.connect(heartscontainer.updatehearts)
#
	#pausemenu.hide()
	#get_tree().paused = false
	#paused = false
#
#func _process(_delta):
	#if Input.is_action_just_pressed("pause"):
		#pause_menu()
#
#func pause_menu():
	#paused = !paused
	#get_tree().paused = paused
#
	#if paused:
		#pausemenu.show()
	#else:
		#pausemenu.hide()


extends BaseScene

@onready var heartscontainer = $CanvasLayer/heartscontainer
@onready var player: Player = $player
@onready var pausemenu = $player/Camera2D2/Pausemenu
@onready var gameover_menu = $player/Camera2D2/restart

var paused: bool = false

# -------------------------------------------------
# SETUP
# -------------------------------------------------
func _ready():
	# Hearts UI
	heartscontainer.setmaxheart(player.maxhealth)
	heartscontainer.updatehearts(player.currenthealth)

	player.healthchanged.connect(heartscontainer.updatehearts)
	player.died.connect(_on_player_died)

	# Game over menu signals
	gameover_menu.restart_requested.connect(_restart_game)
	gameover_menu.quit_requested.connect(_quit_game)

	# Initial state
	pausemenu.hide()
	gameover_menu.hide()

	get_tree().paused = false
	paused = false

# -------------------------------------------------
# INPUT
# -------------------------------------------------
func _process(_delta):
	if Input.is_action_just_pressed("pause") and not gameover_menu.visible:
		pause_menu()

# -------------------------------------------------
# PAUSE (public – called by ESC and Resume button)
# -------------------------------------------------
func pause_menu():
	paused = !paused
	get_tree().paused = paused

	if paused:
		pausemenu.show()
	else:
		pausemenu.hide()

# -------------------------------------------------
# GAME OVER
# -------------------------------------------------
func _on_player_died():
	paused = true
	get_tree().paused = true

	pausemenu.hide()
	gameover_menu.show()

# -------------------------------------------------
# MENU ACTIONS
# -------------------------------------------------
func _restart_game():
	get_tree().paused = false
	Global.speedrun_time = 0.0
	get_tree().reload_current_scene()

func _quit_game():
	get_tree().quit()
