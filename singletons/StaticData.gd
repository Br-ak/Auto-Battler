extends Node

var upgrades = {}
var keybinds = {}
var sound_settings = {}
var weapons = {}
var keybindList = ["attack_primary", "ui_up", "ui_left", "ui_down", "ui_right", "debug_inventory", "weapon_swap"]
var upgrades_file_path = "res://resources/upgrades.json"
var keybinds_file_path = "res://resources/keybinds.json"
var weapons_file_path = "res://resources/weapons.json"
var sound_settings_file_path = "res://resources/sound_settings.json"
var weapon_stat_list = ["attack_damage", "attack_wait", "attack_hits", "attack_type", "attack_origin", "attack_pattern", "attack_pierce", 
"attack_projectile_count", "attack_projectile_offset", "attack_reset_time", "attack_projectile_speed", "attack_range", "attack_base_damage",
"attack_damage_increase", "attack_damage_multiplier", "attack_reset_time_multiplier", "WEAPON_NAME", "ATTACK_NUMBER"]

func _ready():
	upgrades = load_json_file(upgrades_file_path)
	keybinds = load_json_file(keybinds_file_path)
	weapons = load_json_file(weapons_file_path)
	sound_settings = load_json_file(sound_settings_file_path)

func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error Reading File")
	else:
		print("File Not Found")

func save_keybind_data(key, value):
	keybinds["keybinds"][key]["assigned_key"] = value
	var json = JSON.stringify(keybinds, "\t")
	var file = FileAccess.open(keybinds_file_path, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func save_sound_data(key, value):
	sound_settings["sound_settings"][key]["assigned_volume"] = value
	var json = JSON.stringify(sound_settings, "\t")
	var file = FileAccess.open(sound_settings_file_path, FileAccess.WRITE)
	file.store_line(json)
	file.close()
