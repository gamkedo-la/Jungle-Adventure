extends Node

# Built largely by following the doc: https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html#global-gd
var current_scene = null
var in_game_menu = null
var main_menu_scene = load("res://UI/MainMenu.tscn")
var main_music = load("res://Sounds/Music.tscn")
var ambience = load("res://Sounds/Ambience.tscn")
var menu_open = false
var game_live = false
var game_music = null
var game_ambience = null

var room_with_player = Vector2.ZERO
var current_landmark = Vector2.INF
var player_position = Vector2.ZERO


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
func _process(_delta):	
	if game_live:
		if Input.is_action_just_pressed("ui_pause"):
			Global._pause_and_display_menu()
	
	
	
func goto_scene(path):
	# Defer the load until the current scene is done executing code	
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	
	current_scene.free()
	
	print("Loading level...", path)
	var s = load(path)
	
	current_scene = s.instance()
	
	get_tree().get_root().add_child(current_scene)
	
	get_tree().set_current_scene(current_scene)
	
	menu_open = false
	
	
	
func _pause_and_display_menu():
	if !menu_open:
		get_tree().paused = true
		in_game_menu = main_menu_scene.instance()		
		get_tree().get_root().add_child(in_game_menu)		
		in_game_menu._disable_new()
		menu_open = true
	else:
		call_deferred("_deferred_free_menu")

		
func _deferred_free_menu():
	if in_game_menu:
		in_game_menu.free()
	if get_tree().paused == true:
		get_tree().paused = false
	menu_open = false
