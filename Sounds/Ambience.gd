extends Node

var leaving: bool = false
var fade_speed = 80
var target_jungle_db = 0
var target_underwater_db = -40
var last_landmark = Vector2.INF
var room_with_player = Vector2.ZERO
var current_landmark = Vector2.INF

onready var Jungle = $Jungle
onready var UnderWater = $Underwater

func _process(delta):
	room_with_player = Global.room_with_player
	current_landmark = Global.current_landmark
	if leaving:
		if Global.room_with_player != last_landmark:
			leaving = false
			last_landmark = Global.current_landmark
	else:
		if Global.current_landmark != last_landmark:
			leaving = true
	
	_Set_Targets()
	_Set_Levels(delta)


func _Set_Levels(delta):
	var fade_this_frame = fade_speed * delta
	
	if Jungle.volume_db < target_jungle_db - fade_this_frame:
		Jungle.volume_db += fade_this_frame
	if Jungle.volume_db > target_jungle_db + fade_this_frame:
		Jungle.volume_db -= fade_this_frame
	
	if UnderWater.volume_db < target_underwater_db - fade_this_frame:
		UnderWater.volume_db += fade_this_frame
	if UnderWater.volume_db > target_underwater_db + fade_this_frame:
		UnderWater.volume_db -= fade_this_frame


func _Set_Targets():
	if leaving:
		target_jungle_db = -40
		target_underwater_db = 6
	else:
		target_jungle_db = 0
		target_underwater_db = -40





