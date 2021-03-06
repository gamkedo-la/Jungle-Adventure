extends Node2D

var plax_scroll_widths = 3
var plax_scroll_heights = 3

onready var dimensions = get_viewport_rect().size

onready var main_menu = $MenuCanvas/MenuRoot
onready var new_button = $MenuCanvas/MenuRoot/buttonsvb/playhb/play
onready var options = $MenuCanvas/OptionsContainer
onready var credits = $MenuCanvas/CreditsContainer
onready var return_to_game = $MenuCanvas/MenuRoot/buttonsvb/credhb3/return

onready var mast_vol_slider = $MenuCanvas/OptionsContainer/Options/Tabs/Audio/AudioVbox/mvol/mast_volume_slider
onready var music_vol_slider =  $MenuCanvas/OptionsContainer/Options/Tabs/Audio/AudioVbox/musvol/music_volume_slider
onready var amb_vol_slider = $MenuCanvas/OptionsContainer/Options/Tabs/Audio/AudioVbox/ambvol/amb_volume_slider
onready var sfx_vol_slider = $MenuCanvas/OptionsContainer/Options/Tabs/Audio/AudioVbox/sfxvol/sfx_volume_slider


func _ready():
	options.visible = false
	credits.visible = false
	main_menu.visible = true
	Global.menu_open = true
	if !Global.game_live:
		return_to_game.visible = false
	else:
		return_to_game.visible = true
		
	mast_vol_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_vol_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	amb_vol_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Ambience")))
	sfx_vol_slider.value = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	
	#update_volume()
	
	
func _process(_delta):
	#animate_background()
	if Input.is_action_just_pressed("ui_pause"):
		#TODO: Do something smarter here, in case 'unsaved' settings
		if options.visible:
			options.visible = false
			main_menu.visible = true
		#TODO: (fix) There is no way this is the best way to handle pause/unpause
		elif get_tree().paused == true:	
			print("Unpausing")
			Global._pause_and_display_menu()

			
	
#func update_volume():
#	mast_vol_slider.value = UserSettings.master_volume
#	music_vol_slider.value = UserSettings.music_volume
#	sfx_vol_slider.value = UserSettings.effects_volume
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(UserSettings.master_volume))
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(UserSettings.music_volume))
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(UserSettings.effects_volume))

func _on_New_pressed():
	Global.goto_scene("res://World_Test.tscn")


func _disable_new():
	new_button.disabled = true

func _on_options_pressed():
	main_menu.visible = false
	options.visible = true

func _on_credits_pressed():
	main_menu.visible = false
	credits.visible = true

func _on_mast_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))


func _on_music_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))


func _on_amb_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), linear2db(value))


func _on_sfx_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))





func _on_OptsReturn_pressed():
	options.visible = false
	main_menu.visible = true

func _on_CredReturn_pressed():
	credits.visible = false
	main_menu.visible = true

func _on_play_pressed():
	Global.goto_scene("res://World_Test.tscn")



func _on_return_pressed():
	Global._pause_and_display_menu()
