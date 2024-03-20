extends Control
signal _fill_exp_bar
signal _reset_exp_bar

var XP_BAR_MAX = 50.00

@onready var info = $CanvasLayer/info
var temp = info

@onready var killCounter = $CanvasLayer/kills:
	set(value):
		if killCounter == null: # for some reason this is null upon startup for a second
			pass
		else:
			killCounter.text = "Kills: " + str(value)
			

@onready var player_level = $CanvasLayer/level:
	set(value):
		if player_level == null: # for some reason this is null upon startup for a second
			pass
		else:
			_on_reset_exp_bar()
			player_level.text = "Level: " + str(value)

@onready var player_exp = $CanvasLayer/exp:
	set(value):
		if player_exp == null: # for some reason this is null upon startup for a second
			pass
		else:
			player_exp.text = "Exp: " + str(value)
			_on_fill_exp_bar(value)

@onready var exp_bar = $CanvasLayer/ColorRect/TextureRect



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var fps = Engine.get_frames_per_second()
	info.text = "FPS: " + str(fps)


func _on_fill_exp_bar(value):
	if value != 0:
		var percentage_to_fill = float(value / XP_BAR_MAX)
		exp_bar.texture.set_fill_from(Vector2 (percentage_to_fill, 0))
		exp_bar.texture.set_fill_to(Vector2 (percentage_to_fill + 0.1, 0))


func _on_reset_exp_bar():
	exp_bar.texture.set_fill_from(Vector2 (0, 0))
	exp_bar.texture.set_fill_to(Vector2 (0.1, 0))
	